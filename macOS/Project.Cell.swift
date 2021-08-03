import AppKit

extension Project {
    final class Cell: CollectionCell<Info> {
        static let horizontal = (insetsHorizontal * 2) + shape
        static let insetsVertical2 = insetsVertical * 2
        private static let shape = CGFloat(25)
        private static let insetsHorizontal = CGFloat(20)
        private static let insetsVertical = CGFloat(15)
        private static let radius = CGFloat(3)
        private static let radius2 = radius * 2
        private weak var text: CollectionCellText!
        private weak var shape: Shape!
        
        override var item: CollectionItem<Info>? {
            didSet {
                guard
                    item != oldValue,
                    let item = item
                else { return }
                frame = item.rect
                text.frame.size = .init(width: item.rect.width - Self.horizontal,
                                        height: item.rect.height - Self.insetsVertical2)
                text.string = item.info.string
                
                switch item.info.id {
                case .column:
                    shape.path = {
                        $0.addArc(
                            center: .init(x: Self.insetsHorizontal + Self.radius, y: Self.insetsVertical + Self.radius),
                            radius: Self.radius,
                            startAngle: 0,
                            endAngle: CGFloat.pi * 2,
                            clockwise: false)
                        $0.move(to: .init(x: Self.insetsHorizontal + Self.radius, y: Self.insetsVertical + Self.radius2))
                        $0.addLine(to: .init(x: Self.insetsHorizontal + Self.radius, y: Self.insetsVertical + text.frame.size.height))
                        return $0
                    } (CGMutablePath())
                default:
                    shape.path = {
                        $0
                    } (CGMutablePath())
                }
            }
        }
        
        required init?(coder: NSCoder) { nil }
        required init() {
            super.init()
            cornerRadius = 8
            
            let text = CollectionCellText()
            text.frame = .init(
                x: Self.insetsHorizontal + Self.shape,
                y: Self.insetsVertical,
                width: 0,
                height: 0)
            addSublayer(text)
            self.text = text
            
            let shape = Shape()
            shape.fillColor = NSColor.tertiaryLabelColor.cgColor
            shape.lineWidth = 1
            shape.strokeColor = NSColor.tertiaryLabelColor.cgColor
            addSublayer(shape)
            self.shape = shape
        }
    }
}
