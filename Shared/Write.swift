import Foundation
import Kanban

enum Write: Equatable {
    case
    new(Path),
    edit(Path)
}
