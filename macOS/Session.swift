import AppKit
import Combine
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
        switch state.value {
        case let .view(board), let .empty(board):
            state.send(.column(board))
        default:
            break
        }
    }
    
    func newCard() {
        switch state.value {
        case let .view(board), let .empty(board):
            if cloud.archive.value[board].isEmpty {
                newColumn()
            } else {
                state.send(.card(board))
            }
        default:
            break
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
            
            Notifications.send(message: "Created project")
        case let .column(board):
            cloud.add(board: board, column: text.isEmpty ? "Column" : text)
            state.send(.view(board))
            
            Notifications.send(message: "Created column")
        case let .card(board):
            if !text.isEmpty {
                cloud.add(board: board, card: text)        
                Notifications.send(message: "Created card")
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
                Notifications.send(message: "Renamed project")
            case .column:
                cloud.rename(board: path.board, column: path.column, name: text)
                Notifications.send(message: "Renamed column")
            case .card:
                cloud.update(board: path.board, column: path.column, card: path.card, content: text)
                Notifications.send(message: "Updated card")
            }
            state.send(.view(path.board))
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
