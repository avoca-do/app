import AppKit

extension Store.Item {
    final class Purchase: Control {
        required init?(coder: NSCoder) { nil }
        init() {
            let text = Text()
            text.stringValue = "Purchase"
            text.font = .systemFont(ofSize: 14, weight: .regular)
            text.textColor = .labelColor
            
            super.init(layer: true)
            layer!.cornerRadius = 5
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 30).isActive = true
            widthAnchor.constraint(equalToConstant: 110).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed, .highlighted:
                layer!.backgroundColor = NSColor.quaternaryLabelColor.cgColor
            default:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            }
        }
    }
}
