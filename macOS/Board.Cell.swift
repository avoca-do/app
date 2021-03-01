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
                    state = .none
                    
                    switch item.path {
                    case .column:
                        line.isHidden = true
                        circle.isHidden = true
                        left.constant = Metrics.board.item.padding
                    case .card:
                        line.isHidden = false
                        circle.isHidden = false
                        left.constant = Metrics.board.item.padding + Metrics.board.card.left
                    default: break
                    }
                } else {
                    text.attributedStringValue = .init()
                }
            }
        }
        
        var state = State.none {
            didSet {
                switch state {
                case .none:
                    layer!.backgroundColor = .clear
                case .highlighted:
                    switch item?.path {
                    case .column:
                        layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.2).cgColor
                    default:
                        layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
                    }
                case .selected:
                    layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
                }
            }
        }
        
        private weak var text: Text!
        private weak var line: NSView!
        private weak var circle: NSView!
        private weak var left: NSLayoutConstraint!
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            wantsLayer = true
            layer!.cornerRadius = 10
            
            let line = NSView()
            self.line = line
            
            let circle = NSView()
            self.circle = circle
            
            let text = Text()
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(text)
            self.text = text
            
            [line, circle].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.wantsLayer = true
                $0.layer!.backgroundColor = NSColor.tertiaryLabelColor.cgColor
                addSubview($0)
            }
            
            circle.layer!.cornerRadius = Metrics.card.radius
            
            line.topAnchor.constraint(equalTo: circle.bottomAnchor).isActive = true
            line.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.board.item.padding).isActive = true
            line.leftAnchor.constraint(equalTo: leftAnchor, constant: Metrics.board.card.left).isActive = true
            line.widthAnchor.constraint(equalToConstant: Metrics.card.line).isActive = true
            
            circle.centerXAnchor.constraint(equalTo: line.centerXAnchor).isActive = true
            circle.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.board.item.padding).isActive = true
            circle.widthAnchor.constraint(equalToConstant: Metrics.card.circle).isActive = true
            circle.heightAnchor.constraint(equalTo: circle.widthAnchor).isActive = true
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.board.item.padding).isActive = true
            text.rightAnchor.constraint(equalTo: rightAnchor, constant: -Metrics.board.item.padding).isActive = true
            left = text.leftAnchor.constraint(equalTo: leftAnchor)
            left.isActive = true
        }
    }
}
