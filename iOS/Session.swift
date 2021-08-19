import Foundation
import Combine
import Kanban

struct Session {
    var archive = Archive.new
    var board: Int?
    var toast: Toast.Message?
    let modal = PassthroughSubject<App.Modal, Never>()
    
    func newProject() {
        if cloud.archive.value.available {
            modal.send(.write(.create))
        } else {
            modal.send(.purchase)
        }
    }
}
