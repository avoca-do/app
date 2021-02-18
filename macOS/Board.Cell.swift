import AppKit
import Kanban

extension Board {
    final class Cell: NSView {
        var content: Item? {
            didSet {
//                if let page = page {
//                    layer!.borderColor = .clear
//                    layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.03).cgColor
//                    close.state = .on
//                    text.attributedStringValue = page.text
//                } else {
//                    text.attributedStringValue = .init()
//                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            let title = Text()
            title.font = .preferredFont(forTextStyle: .title2)
            title.maximumNumberOfLines = 1
            addSubview(title)
            
            bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: Metrics.board.card.vertical).isActive = true
            
            title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            title.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.board.card.vertical).isActive = true
        }
    }
}
