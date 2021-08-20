import AppKit
import Combine
import UserNotifications
import Kanban

struct Session {
    let state = CurrentValueSubject<State, Never>(.none)
    let text = CurrentValueSubject<String, Never>("")
    let select = PassthroughSubject<Int?, Never>()
    
    func newProject() {
        if cloud.archive.value.available {
            select.send(nil)
            state.send(.create)
        } else {
            let alert = NSAlert()
            alert.alertStyle = .informational
            alert.icon = .init(named: "full")
            alert.messageText = "Unable to create a new project"
            alert.informativeText = """
You have reached your maximum capacity for projects.

Check purchases for more details.
"""
            let capacity = alert.addButton(withTitle: NSLocalizedString("PURCHASES", comment: ""))
            let cancel = alert.addButton(withTitle: NSLocalizedString("CANCEL", comment: ""))
            capacity.keyEquivalent = "\r"
            cancel.keyEquivalent = "\u{1b}"
            if alert.runModal().rawValue == capacity.tag {
                NSApp.store()
            }
        }
    }
    
    func newColumn() {
        if case let .view(board) = state.value {
            state.send(.column(board))
        }
    }
    
    func newCard() {
        if case let .view(board) = state.value {
            if cloud.archive.value[board].isEmpty {
                newColumn()
            } else {
                state.send(.card(board))
            }
        }
    }
    
    func add() {
        let text = text
            .value
            .trimmingCharacters(in: .whitespacesAndNewlines)
        switch state.value {
        case .create:
            cloud.new(board: text.isEmpty ? "Project" : text) {
                select.send(0)
            }
            
            let content = UNMutableNotificationContent()
            content.body = "Created project"
            UNUserNotificationCenter.current().add(.init(identifier: UUID().uuidString, content: content, trigger: nil))
        case let .column(board):
            cloud.add(board: board, column: text.isEmpty ? "Column" : text)
            state.send(.view(board))
            
            let content = UNMutableNotificationContent()
            content.body = "Created column"
            UNUserNotificationCenter.current().add(.init(identifier: UUID().uuidString, content: content, trigger: nil))
        case let .card(board):
            if !text.isEmpty {
                cloud.add(board: board, card: text)
                
                let content = UNMutableNotificationContent()
                content.body = "Created card"
                UNUserNotificationCenter.current().add(.init(identifier: UUID().uuidString, content: content, trigger: nil))
            }
            state.send(.view(board))
        default:
            break
        }
    }
    
    func save() {
        let text = text
            .value
            .trimmingCharacters(in: .whitespacesAndNewlines)
        switch state.value {
        case let .edit(path):
            switch path {
            case .board:
                cloud.rename(board: path.board, name: text)
                state.send(.view(path.board))
                
                let content = UNMutableNotificationContent()
                content.body = "Renamed project"
                UNUserNotificationCenter.current().add(.init(identifier: UUID().uuidString, content: content, trigger: nil))
            case .column:
                cloud.rename(board: path.board, column: path.column, name: text)
                state.send(.view(path.board))
                
                let content = UNMutableNotificationContent()
                content.body = "Renamed column"
                UNUserNotificationCenter.current().add(.init(identifier: UUID().uuidString, content: content, trigger: nil))
            case .card:
                cloud.update(board: path.board, column: path.column, card: path.card, content: text)
                state.send(.view(path.board))
                
                let content = UNMutableNotificationContent()
                content.body = "Updated card"
                UNUserNotificationCenter.current().add(.init(identifier: UUID().uuidString, content: content, trigger: nil))
            }
        default:
            break
        }
    }
    
    func cancel() {
        switch state.value {
        case .create:
            state
                .send(.none)
        case let .column(board), let .card(board):
            state
                .send(.view(board))
        case let .edit(path):
            switch path {
            case .board:
                state
                    .send(.view(path.board))
            default:
                state
                    .send(.view(path.board))
            }
        default:
            break
        }
    }
}
