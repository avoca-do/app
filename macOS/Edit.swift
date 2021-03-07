import AppKit
import Combine

final class Edit: NSView {
    private(set) weak var text: Text!
    private var subs = Set<AnyCancellable>()
    
    override var frame: NSRect {
        didSet {
            text.textContainer!.size.width = bounds.width - (text.textContainerInset.width * 2) - Metrics.edit.right
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = .init(gray: 0, alpha: 0.1)
        
        let top = NSView()
        let bottom = NSView()
        
        let scroll = NSScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.drawsBackground = false
        addSubview(scroll)
        
        let text = Text()
        scroll.documentView = text
        self.text = text
        
        let send = Control.Icon(icon: "arrow.up.square.fill", color: .controlAccentColor)
        send.image.symbolConfiguration = .init(textStyle: .largeTitle)
        send.click.sink {
            text.send()
        }.store(in: &subs)
        
        let cancel = Control.Icon(icon: "xmark", color: .secondaryLabelColor)
        cancel.click.sink {
            text.cancel()
        }.store(in: &subs)
        
        [top, bottom].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.wantsLayer = true
            $0.layer!.backgroundColor = .init(gray: 0, alpha: App.dark ? 0.4 : 0.05)
            addSubview($0)
            
            $0.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            $0.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 2).isActive = true
        }
        
        [send, cancel].forEach {
            addSubview($0)
            
            $0.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        }
        
        top.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bottom.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        scroll.topAnchor.constraint(equalTo: top.bottomAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottom.topAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        send.bottomAnchor.constraint(equalTo: cancel.topAnchor, constant: -5).isActive = true
        cancel.bottomAnchor.constraint(equalTo: bottom.topAnchor, constant: -5).isActive = true
    }
}
