import AppKit

extension Store {
    final class Purchase: Control {
        required init?(coder: NSCoder) { nil }
        init() {
            let text = Text(vibrancy: false)
            text.stringValue = "Purchase"
            text.font = .systemFont(ofSize: 14, weight: .regular)
            text.textColor = .white
            
            super.init(layer: true)
            layer!.cornerRadius = 5
            layer!.backgroundColor = NSColor.systemBlue.cgColor
            addSubview(text)
            
            heightAnchor.constraint(equalToConstant: 30).isActive = true
            widthAnchor.constraint(equalToConstant: 110).isActive = true
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                alphaValue = 0.7
            default:
                alphaValue = 1
            }
        }
    }
}
