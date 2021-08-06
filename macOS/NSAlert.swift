import AppKit
import Kanban

extension NSAlert {
    class func delete(path: Path) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.icon = NSImage(systemSymbolName: "trash.circle.fill", accessibilityDescription: nil)
        alert.messageText = ""
        
        switch path {
        case .board:
            alert.informativeText = cloud.archive.value[path.board].name
        case .column:
            alert.informativeText = cloud.archive.value[path.board][path.column].name
        case .card:
            alert.informativeText = cloud.archive.value[path.board][path.column][path.card].content
        }
        
        let delete = alert.addButton(withTitle: NSLocalizedString("DELETE", comment: ""))
        let cancel = alert.addButton(withTitle: NSLocalizedString("CANCEL", comment: ""))
        delete.keyEquivalent = "\r"
        cancel.keyEquivalent = "\u{1b}"
        if alert.runModal().rawValue == delete.tag {
            session.cancel()
//            Session.edit.send(nil)
//            Session.mutate {
//                switch path {
//                case .column:
//                    $0.drop(path)
//                case .card:
//                    $0.remove(path)
//                default:
//                    $0.delete(path)
//                }
//            }
//
//            switch path {
//            case .board:
//                Session.path = Session.archive.isEmpty(.archive) ? .archive : .board(0)
//            default: break
//            }
//
//            Session.scroll.send()
        }
    }
}
