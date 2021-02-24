import AppKit
import Combine
import Kanban

extension Board.Cell {
    final class Edit: NSPopover {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(path: Path) {
            super.init()
            behavior = .transient
            contentSize = .init(width: 180, height: 120)
            contentViewController = .init()
            contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
            
            let edit = Control.Tool(title: NSLocalizedString("Edit", comment: ""), icon: "text.cursor")
            edit.click.sink {
                
            }.store(in: &subs)
            
            let delete = Control.Tool(title: NSLocalizedString("Delete", comment: ""), icon: "trash")
            delete.click.sink {
                
            }.store(in: &subs)
            
            [edit, delete].forEach {
                contentViewController!.view.addSubview($0)
                
                $0.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 20).isActive = true
                $0.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor, constant: -20).isActive = true
            }
            
            edit.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 20).isActive = true
            delete.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -20).isActive = true
        }
    }
}
