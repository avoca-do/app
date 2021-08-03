import Foundation
import Kanban

extension Project {
    struct Info: CollectionItemInfo {
        let id: Path
        let string: NSAttributedString
    }
}
