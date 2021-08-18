import Foundation
import Kanban

struct Session {
    var archive = Archive.new
    var path = Path.archive
    let decimal = NumberFormatter()
    let percentage = NumberFormatter()
    
    init() {
        decimal.numberStyle = .decimal
        percentage.numberStyle = .percent
    }
}
