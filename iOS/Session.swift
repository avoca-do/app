import Foundation
import Combine
import Kanban

struct Session {
    var archive = Archive.new
    var board: Int?
    let modal = PassthroughSubject<App.Modal, Never>()
    
    mutating func newProject() {
        if cloud.archive.value.available {
            modal.send(.write(.create))
        } else {
            modal.send(.purchase)
        }
    }
    
    func finish(text: String, write: App.Modal.Write) {
        switch write {
        case .create:
            cloud.new(board: text.isEmpty ? "Project" : text) {
                Notifications.send(message: "Created project")
            }
        case let .column(board):
            cloud.add(board: board, column: text.isEmpty ? "Column" : text)
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
    
    /*
     func add() {
         let text = text
             .value
             .trimmingCharacters(in: .whitespacesAndNewlines)
         switch state.value {
         case .create:
             cloud.new(board: text.isEmpty ? "Project" : text) {
                 select.send(0)
             }
             Toast.show(message: .init(title: "Created project", icon: "plus"))
         case let .column(board):
             cloud.add(board: board, column: text.isEmpty ? "Column" : text)
             state.send(.view(board))
             Toast.show(message: .init(title: "Created column", icon: "plus"))
         case let .card(board):
             if !text.isEmpty {
                 cloud.add(board: board, card: text)
                 Toast.show(message: .init(title: "Created card", icon: "plus"))
             }
             state.send(.view(board))
         default:
             break
         }
     }
     
     func save() {
         let text = text
             .value
             .trimmingCharacters(in: .whitespacesAndNewlines)
         switch state.value {
         case let .edit(path):
             switch path {
             case .board:
                 cloud.rename(board: path.board, name: text)
                 state.send(.view(path.board))
                 Toast.show(message: .init(title: "Renamed project", icon: "square.and.pencil"))
             case .column:
                 cloud.rename(board: path.board, column: path.column, name: text)
                 state.send(.view(path.board))
                 Toast.show(message: .init(title: "Renamed column", icon: "square.and.pencil"))
             case .card:
                 cloud.update(board: path.board, column: path.column, card: path.card, content: text)
                 state.send(.view(path.board))
                 Toast.show(message: .init(title: "Updated card", icon: "square.and.pencil"))
             }
         case .create:
             cloud.new(board: text.isEmpty ? "Project" : text) {
                 select.send(0)
             }
             Toast.show(message: .init(title: "Created project", icon: "plus"))
         case let .column(board):
             cloud.add(board: board, column: text.isEmpty ? "Column" : text)
             state.send(.view(board))
             Toast.show(message: .init(title: "Created column", icon: "plus"))
         case let .card(board):
             if !text.isEmpty {
                 cloud.add(board: board, card: text)
                 Toast.show(message: .init(title: "Created card", icon: "plus"))
             }
             state.send(.view(board))
         default:
             break
         }
     }
     */
}
