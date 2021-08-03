import AppKit

extension Sidebar {
    final class Cell: CollectionCell<Info> {
        static let insetsHorizontal2 = insetsHorizontal * 2
        static let insetsVertical2 = insetsVertical * 2
        private static let insetsHorizontal = CGFloat(20)
        private static let insetsVertical = CGFloat(12)
        private weak var text: CollectionCellText!
        private weak var separator: Shape!
        
        override var first: Bool {
            didSet {
                separator.isHidden = first
            }
        }
        
        override var item: CollectionItem<Info>? {
            didSet {
                guard
                    item != oldValue,
                    let item = item
                else { return }
                frame = item.rect
                text.frame.size = .init(width: item.rect.width - Self.insetsHorizontal2, height: item.rect.height - Self.insetsVertical2)
                text.string = item.info.string
            }
        }
        
        override var state: CollectionCellState {
            didSet {
                switch state {
                case .none, .highlighted:
                    text.string = item?.info.string
                case .pressed:
                    text.string = item?.info.stringHighlighted
                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        required init() {
            super.init()
            cornerRadius = 8
            
            let text = CollectionCellText()
            text.frame = .init(
                x: Self.insetsHorizontal,
                y: Self.insetsVertical,
                width: 0,
                height: 0)
            addSublayer(text)
            self.text = text
            
            let separator = Shape()
            separator.fillColor = .clear
            separator.lineWidth = 1
            separator.strokeColor = NSColor.separatorColor.cgColor
            separator.path = .init(rect: .init(x: Self.insetsHorizontal, y: -1, width: List.width - Self.insetsHorizontal2, height: 0), transform: nil)
            addSublayer(separator)
            self.separator = separator
        }
    }
}
