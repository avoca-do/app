import Foundation
import Combine
import Kanban

struct Session {
    let state = CurrentValueSubject<State, Never>(.none)
}
