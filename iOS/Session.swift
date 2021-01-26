import Foundation
import Combine
import Kanban

struct Session {
    var archive = Archive()
    var typing = false
    let become = PassthroughSubject<Void, Never>()
    let board = PassthroughSubject<Int?, Never>()
    
    subscript(_ board: Int) -> Kanban.Board {
        get {
            archive[board]
        }
        set {
            archive[board] = newValue
        }
    }
}
