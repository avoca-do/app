import Foundation
import Kanban

extension Board {
    struct Item {
        let text: NSAttributedString
        let rect: CGRect
        
        init(path: Path, x: CGFloat, y: CGFloat) {
            text = .make([.init(string: Session.shared.archive.value[title: path])])
            rect = {
                .init(x: x, y: y,
                      width: ceil($0.width) + $1,
                      height: ceil($0.height) + $1)
            } (text.boundingRect(with: Metrics.board.item.size, options: [.usesFontLeading, .usesLineFragmentOrigin]), Metrics.board.item.padding * 2)
        }
    }
}
