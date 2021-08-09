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

Check the purchases section for more details.
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
        case let .column(board):
            cloud.add(board: board, column: text.isEmpty ? "Column" : text)
            state.send(.view(board))
        case let .card(board):
            if !text.isEmpty {
                cloud.add(board: board, card: text)
            }
            state.send(.view(board))
        default:
            break
        }
    }
    
    func save() {
        
    }
    
    func cancel(hard: Bool) {
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
                if hard {
                    state
                        .send(.none)
                    select
                        .send(nil)
                } else {
                    state
                        .send(.view(path.board))
                }
            default:
                state
                    .send(.view(path.board))
            }
        default:
            break
        }
    }
}
