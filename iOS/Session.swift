import Foundation
import Combine
import Kanban

struct Session {
    var archive = Archive()
    var typing = false
    let become = PassthroughSubject<Void, Never>()
    let dismiss = PassthroughSubject<Void, Never>()
    let board = PassthroughSubject<Int?, Never>()
    let card = PassthroughSubject<(Int, Int)?, Never>()
    
    var count: Int {
        archive.count
    }
    
    var isEmpty: Bool {
        archive.isEmpty
    }
    
    subscript(_ board: Int) -> Kanban.Board {
        get {
            archive[board]
        }
        set {
            archive[board] = newValue
        }
    }
}
