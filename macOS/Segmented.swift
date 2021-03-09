import AppKit
import Combine

final class Segmented: NSView {
    let selected = CurrentValueSubject<Int, Never>(0)
    private var subs = Set<AnyCancellable>()
    
    private weak var indicator: NSView!
    private weak var indicatorCenter: NSLayoutConstraint? {
        didSet {
            oldValue?.isActive = false
            indicatorCenter!.isActive = true
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(items: [String]) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
        layer!.cornerRadius = Metrics.corners
        
        let indicator = NSView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.wantsLayer = true
        indicator.layer!.backgroundColor = NSColor.controlAccentColor.cgColor
        indicator.layer!.cornerRadius = Metrics.corners
        addSubview(indicator)
        self.indicator = indicator
        
        var left = leftAnchor
        items.enumerated().forEach { index in
            let item = Item(index: index.0, title: index.1)
            item.click.sink { [weak self] in
                guard index.0 != self?.selected.value else { return }
                self?.selected.value = index.0
            }.store(in: &subs)
            addSubview(item)
            
            item.leftAnchor.constraint(equalTo: left).isActive = true
            item.topAnchor.constraint(equalTo: topAnchor).isActive = true
            item.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            item.widthAnchor.constraint(equalTo: indicator.widthAnchor).isActive = true
            left = item.rightAnchor
        }
        
        heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        indicator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        indicator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        indicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / .init(items.count)).isActive = true
        
        layoutSubtreeIfNeeded()
        
        selected.sink { [weak self] _ in
            self?.update()
        }.store(in: &subs)
    }
    
    private func update() {
        subviews.compactMap { $0 as? Item }.forEach {
            if selected.value == $0.index {
                $0.label.textColor = .black
                indicatorCenter = indicator.centerXAnchor.constraint(equalTo: $0.centerXAnchor)
            } else {
                $0.label.textColor = .secondaryLabelColor
            }
            
        }
        
        NSAnimationContext.runAnimationGroup {
            $0.duration = 0.35
            $0.allowsImplicitAnimation = true
            layoutSubtreeIfNeeded()
        }
    }
}

private final class Item: Control {
    let index: Int
    private(set) weak var label: Text!
    
    required init?(coder: NSCoder) { nil }
    init(index: Int, title: String) {
        self.index = index
        super.init()
        
        let label = Text()
        label.font = .preferredFont(forTextStyle: .callout)
        label.stringValue = title
        addSubview(label)
        self.label = label
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
