import AppKit

extension Project {
    final class Cell: CollectionCell<Info> {
        static let horizontal = (insetsHorizontal * 2) + shape
        static let insetsVertical2 = insetsVertical * 2
        private static let shape = CGFloat(30)
        private static let insetsHorizontal = CGFloat(20)
        private static let insetsVertical = CGFloat(15)
        private static let radius = CGFloat(3)
        private static let insetShape = insetsHorizontal + 6
        private static let insetHorizontalCircle = insetShape + radius
        private static let insetVerticalCircle = insetsVertical + radius
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
                            center: .init(x: Self.insetHorizontalCircle, y: Self.insetVerticalCircle),
                            radius: Self.radius,
                            startAngle: 0,
                            endAngle: CGFloat.pi * 2,
                            clockwise: false)
                        $0.move(to: .init(x: Self.insetShape, y: Self.insetVerticalCircle))
                        $0.addLine(to: .init(x: Self.insetsHorizontal, y: Self.insetVerticalCircle))
                        $0.addLine(to: .init(x: Self.insetsHorizontal, y: Self.insetsVertical + text.frame.size.height))
                        return $0
                    } (CGMutablePath())
                default:
                    shape.path = {
                        $0.move(to: .init(x: Self.insetsHorizontal, y: Self.insetsVertical + (text.frame.size.height / 2)))
                        $0.addLine(to: .init(x: Self.insetHorizontalCircle, y: Self.insetsVertical + (text.frame.size.height / 2)))
                        $0.move(to: .init(x: Self.insetHorizontalCircle, y: Self.insetsVertical))
                        $0.addLine(to: .init(x: Self.insetHorizontalCircle, y: Self.insetsVertical + text.frame.size.height))
                        return $0
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
            shape.fillColor = .clear
            shape.lineWidth = 1
            shape.strokeColor = NSColor.tertiaryLabelColor.cgColor
            addSublayer(shape)
            self.shape = shape
        }
    }
}
