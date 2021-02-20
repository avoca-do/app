import AppKit
import Kanban

extension Board {
    struct Item: Hashable {
        let path: Path
        let text: NSAttributedString
        let rect: CGRect
        
        init(path: Path, x: CGFloat, y: CGFloat) {
            self.path = path
            var size = Metrics.board.item.size
            switch path {
            case .column:
                text = .make([.init(string: Session.archive[title: path] + " ",
                                    attributes: [
                                        .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title2).pointSize, weight: .bold),
                                        .foregroundColor: NSColor.labelColor]),
                              .init(string: Session.decimal.string(from: NSNumber(value: Session.archive.count(path)))!,
                                                  attributes: [
                                                    .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .regular),
                                                    .foregroundColor: NSColor.secondaryLabelColor])])
            case .card:
                text = .make([.init(string: Session.archive[content: path],
                                    attributes: [
                                        .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .regular),
                                        .foregroundColor: NSColor.labelColor,
                                        .kern: NSNumber(value: 1)])])
                size.width -= Metrics.board.card.left
            default:
                text = .init()
            }
            
            rect = {
                .init(x: x, y: y,
                      width: Metrics.board.item.padding2 + Metrics.board.item.size.width,
                      height: $0.height + Metrics.board.item.padding2)
            } (CTFramesetterSuggestFrameSizeWithConstraints(CTFramesetterCreateWithAttributedString(text), CFRange(), nil, size, nil))
        }
        
        func hash(into: inout Hasher) {
            into.combine(path)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.path == rhs.path
        }
    }
}
