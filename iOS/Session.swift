import Foundation
import Combine
import Kanban

struct Session {
    var archive = Archive()
    var typing = false
    let decimal = NumberFormatter()
    let percentage = NumberFormatter()
    let become = PassthroughSubject<Field.Mode, Never>()
    let dismiss = PassthroughSubject<Void, Never>()
    let board = PassthroughSubject<Int?, Never>()
    let card = PassthroughSubject<Position?, Never>()
    
    var count: Int {
        archive.count
    }
    
    var isEmpty: Bool {
        archive.isEmpty
    }
    
    init() {
        decimal.numberStyle = .decimal
        percentage.numberStyle = .percent
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
