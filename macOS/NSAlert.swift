import AppKit
import Kanban

extension NSAlert {
    class func delete(path: Path) {
        switch path {
        case .board:
            confirm(path: path, message: cloud.archive.value[path.board].name)
        case .column:
            confirm(path: path, message: cloud.archive.value[path.board][path.column].name)
        default:
            confirmed(path: path)
        }
    }
    
    private class func confirm(path: Path, message: String) {
        let alert = NSAlert()
        alert.alertStyle = .warning
        alert.icon = .init(systemSymbolName: "trash", accessibilityDescription: nil)
        alert.messageText = ""
        alert.informativeText = message
        
        let delete = alert.addButton(withTitle: "DELETE")
        let cancel = alert.addButton(withTitle: "CANCEL")
        delete.keyEquivalent = "\r"
        cancel.keyEquivalent = "\u{1b}"
        if alert.runModal().rawValue == delete.tag {
            confirmed(path: path)
        }
    }
    
    private class func confirmed(path: Path) {
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
