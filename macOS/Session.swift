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
    
    func add() {
        let text = text
            .value
            .trimmingCharacters(in: .whitespacesAndNewlines)
        switch state.value {
        case .create:
            cloud.new(board: text.isEmpty ? "Project" : text) {
                select.send(0)
            }
            Toast.show(message: .init(title: "Created project", icon: "plus"))
        case let .column(board):
            cloud.add(board: board, column: text.isEmpty ? "Column" : text)
            state.send(.view(board))
            Toast.show(message: .init(title: "Created column", icon: "plus"))
        case let .card(board):
            if !text.isEmpty {
                cloud.add(board: board, card: text)
                Toast.show(message: .init(title: "Created card", icon: "plus"))
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
                Toast.show(message: .init(title: "Renamed project", icon: "square.and.pencil"))
            case .column:
                cloud.rename(board: path.board, column: path.column, name: text)
                state.send(.view(path.board))
                Toast.show(message: .init(title: "Renamed column", icon: "square.and.pencil"))
            case .card:
                cloud.update(board: path.board, column: path.column, card: path.card, content: text)
                state.send(.view(path.board))
                Toast.show(message: .init(title: "Updated card", icon: "square.and.pencil"))
            }
        case .create:
            cloud.new(board: text.isEmpty ? "Project" : text) {
                select.send(0)
            }
            Toast.show(message: .init(title: "Created project", icon: "plus"))
        case let .column(board):
            cloud.add(board: board, column: text.isEmpty ? "Column" : text)
            state.send(.view(board))
            Toast.show(message: .init(title: "Created column", icon: "plus"))
        case let .card(board):
            if !text.isEmpty {
                cloud.add(board: board, card: text)
                Toast.show(message: .init(title: "Created card", icon: "plus"))
            }
            state.send(.view(board))
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
