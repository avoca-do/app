import AppKit
import Kanban

extension Board {
    final class Cell: NSView {
        var item: Item? {
            didSet {
                if let item = item {
                    layer!.borderColor = .clear
                    layer!.backgroundColor = .clear
                    text.attributedStringValue = item.text
                    frame = item.rect
                } else {
                    text.attributedStringValue = .init()
                }
            }
        }
        
        private weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            wantsLayer = true
            layer!.cornerRadius = 8
            layer!.borderWidth = 1
            
            let text = Text()
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(text)
            self.text = text
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.board.item.padding).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: Metrics.board.item.padding).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -Metrics.board.item.padding).isActive = true
            
            addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .activeInActiveApp, .inVisibleRect], owner: self))
        }
        
        override func mouseEntered(with: NSEvent) {
            layer!.borderColor = NSColor.controlAccentColor.cgColor
            layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.03).cgColor
        }
        
        override func mouseExited(with: NSEvent) {
            layer!.borderColor = .clear
            layer!.backgroundColor = .clear
        }
    }
}
