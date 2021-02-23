import AppKit
import Combine

extension Projects {
    final class Columns: NSPopover {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            behavior = .transient
            contentSize = .init(width: 240, height: 180)
            contentViewController = .init()
            contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
            
            let plus = Control.Tool(title: NSLocalizedString("New column", comment: ""), icon: "plus")
            plus.click.sink { [weak self] in
                
            }.store(in: &subs)
            
            [plus].forEach {
                contentViewController!.view.addSubview($0)
                
                $0.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 20).isActive = true
                $0.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor, constant: -20).isActive = true
            }
            
            plus.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -20).isActive = true
        }
    }
}
