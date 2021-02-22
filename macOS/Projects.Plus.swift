import AppKit
import Combine

extension Projects {
    final class Plus: NSPopover {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            behavior = .transient
            contentSize = .init(width: 240, height: 160)
            contentViewController = .init()
            contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
            
            let field = Field(write: .new(.archive))
            field.finish.sink { [weak self] in
                self?.close()
            }.store(in: &subs)
            contentViewController!.view.addSubview(field)
            
            let start = Control.Rectangle(title: NSLocalizedString("Start", comment: ""))
            start.layer!.backgroundColor = NSColor.controlAccentColor.cgColor
            start.text.textColor = .black
            start.click.sink {
                field.done()
            }.store(in: &subs)
            contentViewController!.view.addSubview(start)
            
            field.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
            field.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 40).isActive = true
            field.widthAnchor.constraint(equalToConstant: 160).isActive = true
            
            start.widthAnchor.constraint(equalToConstant: 160).isActive = true
            start.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
            start.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -30).isActive = true
        }
    }
}
