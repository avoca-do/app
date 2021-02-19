import AppKit
import Kanban

extension Board {
    struct Item: Hashable {
        let path: Path
        let text: NSAttributedString
        let rect: CGRect
        
        init(path: Path, x: CGFloat, y: CGFloat) {
            self.path = path
            text = .make([.init(string: Session.archive[title: path],
                                attributes: [.font: NSFont.preferredFont(forTextStyle: .title2)])])
            rect = {
                .init(x: x, y: y,
                      width: Metrics.board.item.size.width + $1,
                      height: ceil($0.height) + $1)
            } (text.boundingRect(with: Metrics.board.item.size, options: [.usesFontLeading, .usesLineFragmentOrigin]), Metrics.board.item.padding * 2)
        }
        
        func hash(into: inout Hasher) {
            into.combine(path)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.path == rhs.path
        }
    }
}
