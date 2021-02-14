import Foundation
import Combine
import Kanban

struct Session {
    var typing = false
    var path = Path.archive
    var archive = Archive()
    let purchases = Purchases()
    let decimal = NumberFormatter()
    let percentage = NumberFormatter()
    let become = PassthroughSubject<Field.Mode, Never>()
    let dismiss = PassthroughSubject<Void, Never>()
    
    init() {
        decimal.numberStyle = .decimal
        percentage.numberStyle = .percent
    }
}
