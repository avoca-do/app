import AppKit
import UserNotifications
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
                let content = UNMutableNotificationContent()
                content.body = "Deleted project"
                UNUserNotificationCenter.current().add(.init(identifier: UUID().uuidString, content: content, trigger: nil))
                
                session.select.send(nil)
                session.state.send(.none)
                cloud.delete(board: path.board)
            case .column:
                let content = UNMutableNotificationContent()
                content.body = "Deleted column"
                UNUserNotificationCenter.current().add(.init(identifier: UUID().uuidString, content: content, trigger: nil))
                
                session.cancel()
                cloud.delete(board: path.board, column: path.column)
            case .card:
                let content = UNMutableNotificationContent()
                content.body = "Deleted card"
                UNUserNotificationCenter.current().add(.init(identifier: UUID().uuidString, content: content, trigger: nil))
                
                session.cancel()
                cloud.delete(board: path.board, column: path.column, card: path.card)
            }
        }
    }
}
