import AppKit
import Combine
import Kanban

extension Projects {
    final class Settings: NSPopover {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(path: Path) {
            super.init()
            behavior = .transient
            contentSize = .init(width: 240, height: 180)
            contentViewController = .init()
            contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
            
            let name = Text()
            name.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold)
            name.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            name.maximumNumberOfLines = 2
            
            switch path {
            case .column:
                name.stringValue = Session.archive[title: path]
            default:
                name.stringValue = Session.archive[name: path]
            }
            
            let field = Plus.Field(write: .edit(path))
            field.isHidden = true
            
            let save = Control.Rectangle(title: NSLocalizedString("Save", comment: ""))
            save.layer!.backgroundColor = NSColor.controlAccentColor.cgColor
            save.text.textColor = .black
            save.state = .hidden
            
            let cancel = Control.Rectangle(title: NSLocalizedString("Cancel", comment: ""))
            cancel.text.textColor = .secondaryLabelColor
            cancel.state = .hidden
            
            let rename = Control.Tool(title: NSLocalizedString("Rename", comment: ""), icon: "text.cursor")
            let delete = Control.Tool(title: NSLocalizedString("Delete", comment: ""), icon: "trash")
            
            field.finish.sink { [weak self] in
                self?.close()
            }.store(in: &subs)
            
            save.click.sink {
                field.done()
            }
            .store(in: &subs)
            
            cancel.click.sink { [weak self] in
                rename.state = .on
                save.state = .hidden
                cancel.state = .hidden
                field.isHidden = true
                NSAnimationContext.runAnimationGroup {
                    $0.duration = 0.3
                    $0.timingFunction = .init(name: .easeInEaseOut)
                    $0.allowsImplicitAnimation = true
                    self?.contentSize = .init(width: 240, height: 180)
                }
            }.store(in: &subs)
            
            rename.click.sink { [weak self] in
                rename.state = .hidden
                save.state = .on
                cancel.state = .on
                field.isHidden = false
                NSAnimationContext.runAnimationGroup {
                    $0.duration = 0.3
                    $0.timingFunction = .init(name: .easeInEaseOut)
                    $0.allowsImplicitAnimation = true
                    self?.contentSize = .init(width: 240, height: 340)
                }
            }.store(in: &subs)
            
            delete.click.sink {
                NSAlert.delete(path)
            }.store(in: &subs)
            
            [name, field, save, cancel, rename, delete].forEach {
                contentViewController!.view.addSubview($0)
                
                $0.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 20).isActive = true
                $0.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor, constant: -20).isActive = true
            }
            
            name.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 20).isActive = true
            field.bottomAnchor.constraint(equalTo: save.topAnchor, constant: -20).isActive = true
            save.bottomAnchor.constraint(equalTo: cancel.topAnchor, constant: -5).isActive = true
            cancel.bottomAnchor.constraint(equalTo: rename.topAnchor, constant: -5).isActive = true
            rename.bottomAnchor.constraint(equalTo: delete.topAnchor, constant: -5).isActive = true
            delete.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -20).isActive = true
        }
    }
}
