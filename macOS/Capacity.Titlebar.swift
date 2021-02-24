import AppKit
import Combine
import Kanban

extension Capacity {
    final class Titlebar: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            Session.purchases.loading.removeDuplicates().sink { [weak self] _ in
                guard let self = self else { return }
                self.subviews.forEach { $0.removeFromSuperview() }
                
                let bar = NSView()
                bar.translatesAutoresizingMaskIntoConstraints = false
                bar.wantsLayer = true
                
                let count = Text()
                count.stringValue = Session.decimal.string(from: .init(value: Session.archive.count(.archive)))!
                    + "/" + Session.decimal.string(from: .init(value: Defaults.capacity))!
                count.textColor = .labelColor
                count.font = .systemFont(ofSize: 16, weight: .bold)
                
                let title = Text()
                title.stringValue = NSLocalizedString("Projects", comment: "")
                title.font = .preferredFont(forTextStyle: .callout)
                title.textColor = .secondaryLabelColor
                
                let total = CAShapeLayer()
                total.frame = .init(x: 20, y: 0, width: 200, height: 10)
                total.strokeColor = .init(gray: 0, alpha: 0.3)
                total.fillColor = .clear
                total.lineWidth = 8
                total.lineCap = .round
                total.path = {
                    $0.move(to: .init(x: 0, y: 5))
                    $0.addLine(to: .init(x: 200, y: 5))
                    return $0
                } (CGMutablePath())
                bar.layer!.addSublayer(total)
                
                let used = CAShapeLayer()
                used.frame = .init(x: 20, y: 0, width: 200, height: 10)
                used.strokeColor = Session.archive.available ? NSColor.controlAccentColor.cgColor : NSColor.systemPink.cgColor
                used.fillColor = .clear
                used.lineWidth = 6
                used.lineCap = .round
                used.path = {
                    $0.move(to: .init(x: 0, y: 5))
                    $0.addLine(to: .init(x: CGFloat(min(Session.archive.count(.archive), Defaults.capacity)) / .init(Defaults.capacity) * 200, y: 5))
                    return $0
                } (CGMutablePath())
                bar.layer!.addSublayer(used)
                
                [bar, count, title].forEach {
                    self.addSubview($0)
                    $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                }
                
                bar.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -2).isActive = true
                bar.widthAnchor.constraint(equalToConstant: 240).isActive = true
                bar.heightAnchor.constraint(equalToConstant: 10).isActive = true
                
                count.rightAnchor.constraint(equalTo: title.leftAnchor, constant: -5).isActive = true
                title.rightAnchor.constraint(equalTo: bar.leftAnchor).isActive = true
            }.store(in: &subs)
        }
    }
}
