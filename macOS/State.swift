import Foundation
import Kanban

enum State: Equatable {
    case
    none,
    create,
    view(Int),
    empty(Int),
    column(Int),
    card(Int),
    edit(Path)
}
