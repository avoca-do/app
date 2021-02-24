import AppKit
import Kanban

extension NSAlert {
    class func delete(_ path: Path) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.icon = NSImage(systemSymbolName: "trash", accessibilityDescription: nil)
        
        switch path {
        case .column:
            alert.messageText = NSLocalizedString("Delete column?", comment: "")
            alert.informativeText = Session.archive[title: path]
        case .card:
            alert.messageText = NSLocalizedString("Delete card?", comment: "")
            alert.informativeText = Session.archive[content: path]
        default:
            alert.messageText = NSLocalizedString("Delete project?", comment: "")
            alert.informativeText = Session.archive[name: path]
        }
        
        let delete = alert.addButton(withTitle: NSLocalizedString("Delete", comment: ""))
        let cancel = alert.addButton(withTitle: NSLocalizedString("Cancel", comment: ""))
        delete.keyEquivalent = "\r"
        cancel.keyEquivalent = "\u{1b}"
        if alert.runModal().rawValue == delete.tag {
            Session.mutate {
                switch path {
                case .column:
                    $0.drop(path)
                case .card:
                    $0.remove(path)
                default:
                    $0.delete(path)
                }
            }
            
            switch path {
            case .board:
                Session.path = Session.archive.isEmpty(.archive) ? .archive : .board(0)
            default: break
            }
            
            Session.scroll.send()
        }
    }
}
