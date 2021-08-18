import Foundation
import Combine
import Kanban

struct Session {
    var archive = Archive.new
    var toast: Toast.Message?
    var modal: Modal?
    
    init() {
        
    }
}
