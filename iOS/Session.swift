import UIKit
import Combine
import Kanban

struct Session {
    var archive = Archive.new
    var board: Int?
    var column = 0
    let modal = PassthroughSubject<App.Modal, Never>()
    
    func newProject() {
        if archive.available {
            modal.send(.write(.create))
        } else {
            modal.send(.purchase)
        }
    }
    
    func finish(text: String, write: App.Modal.Write) {
        switch write {
        case .create:
            cloud.new(board: text.isEmpty ? "Project" : text) {
                
                if Defaults.rate {
                    UIApplication.shared.review()
                }
                
                Notifications.send(message: "Created project")
            }
        case let .column(board):
            cloud.add(board: board, column: text.isEmpty ? "Column" : text)
            
            if Defaults.rate {
                UIApplication.shared.review()
            }
            
            Notifications.send(message: "Created column")
        case let .card(board):
            if !text.isEmpty {
                cloud.add(board: board, card: text)   
                Notifications.send(message: "Created card")
            }
        case let .edit(path):
            switch path {
            case .board:
                cloud.rename(board: path.board, name: text)
                Notifications.send(message: "Renamed project")
            case .column:
                cloud.rename(board: path.board, column: path.column, name: text)
                Notifications.send(message: "Renamed column")
            case .card:
                cloud.update(board: path.board, column: path.column, card: path.card, content: text)
                Notifications.send(message: "Updated card")
            }
        }
    }
}
