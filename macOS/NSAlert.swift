import AppKit
import Kanban

extension NSAlert {
    class func delete(path: Path) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.icon = .init(systemSymbolName: "trash", accessibilityDescription: nil)
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
            switch path {
            case .board:
                Notifications.send(message: "Deleted project")
                
                session.select.send(nil)
                session.state.send(.none)
                cloud.delete(board: path.board)
            case .column:
                Notifications.send(message: "Deleted column")
                
                session.cancel()
                cloud.delete(board: path.board, column: path.column)
            case .card:
                Notifications.send(message: "Deleted card")
                
                session.cancel()
                cloud.delete(board: path.board, column: path.column, card: path.card)
            }
        }
    }
}
