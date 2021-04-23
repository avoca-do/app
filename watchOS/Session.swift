import Foundation
import Kanban

struct Session {
    var archive = Archive.new
    var path = Path.archive
    var open = false
    let decimal = NumberFormatter()
    let percentage = NumberFormatter()
    
    init() {
        decimal.numberStyle = .decimal
        percentage.numberStyle = .percent
    }
}
