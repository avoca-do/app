import Foundation
import Kanban

extension App.Modal {
    enum Write: Equatable {
        case
        create,
        column(Int),
        card(Int),
        edit(Path)
    }
}
