import Foundation
import Combine
import Kanban

struct Session {
    var board: Kanban.Board?
    var typing = false
    let become = PassthroughSubject<Void, Never>()
}
