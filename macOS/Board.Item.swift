import AppKit
import Kanban

extension Board {
    struct Item {
        var rect: CGRect
        let text: NSAttributedString
        
        init(path: Path) {
            text = .make([.init(string: Session.shared.archive.value[title: path])])
            rect = text.boundingRect(with: Metrics.board.column.size, options: [.usesFontLeading, .usesLineFragmentOrigin])
        }
    }
}
