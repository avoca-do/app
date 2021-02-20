import AppKit
import Kanban

extension Board {
    final class Cell: NSView {
        var item: Item? {
            didSet {
                if let item = item {
                    layer!.borderColor = .clear
                    layer!.backgroundColor = .clear
                    frame = item.rect
                    text.attributedStringValue = item.text
                    
                    switch item.path {
                    case .column:
                        left.constant = Metrics.board.item.padding
                    case .card:
                        left.constant = Metrics.board.item.padding + Metrics.board.card.left
                    default:
                        left.constant = 0
                    }
                } else {
                    text.attributedStringValue = .init()
                }
            }
        }
        
        private weak var text: Text!
        private weak var left: NSLayoutConstraint!
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            wantsLayer = true
            layer!.cornerRadius = 8
            
            let text = Text()
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(text)
            self.text = text
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.board.item.padding).isActive = true
            text.rightAnchor.constraint(equalTo: rightAnchor, constant: -Metrics.board.item.padding).isActive = true
            left = text.leftAnchor.constraint(equalTo: leftAnchor)
            left.isActive = true
            
            addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .activeInActiveApp, .inVisibleRect], owner: self))
        }
        
        override func mouseEntered(with: NSEvent) {
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
        }
        
        override func mouseExited(with: NSEvent) {
            layer!.backgroundColor = .clear
        }
    }
}
