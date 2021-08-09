import Foundation
import Combine
import Kanban

struct Session {
    let state = CurrentValueSubject<State, Never>(.none)
    let text = CurrentValueSubject<String, Never>("")
    let select = PassthroughSubject<Int?, Never>()
    
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
