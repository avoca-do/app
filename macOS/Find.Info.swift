import Foundation
import Kanban

extension Find {
    struct Info: CollectionItemInfo {
        let id: Path
        let string: NSAttributedString
        let first: Bool
    }
}
