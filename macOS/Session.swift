import Foundation
import Combine
import Kanban

struct Session {
    let state = CurrentValueSubject<State, Never>(.none)
    
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
                    .send(.none)
            default:
                state
                    .send(.view(path.board))
            }
        default:
            break
        }
    }
}
