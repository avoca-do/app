import AppKit

extension Control {
    final class Icon: Control {
        private(set) weak var image: NSImageView!
        private let color: NSColor
        
        required init?(coder: NSCoder) { nil }
        init(icon: String, color: NSColor) {
            self.color = color
            super.init()
            let image = NSImageView(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentTintColor = color
            image.symbolConfiguration = .init(textStyle: .title3)
            addSubview(image)
            self.image = image
            
            widthAnchor.constraint(equalToConstant: 35).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .pressed:
                image.contentTintColor = .labelColor
            case .highlighted:
                alphaValue = 0.7
            default:
                alphaValue = 1
                image.contentTintColor = color
            }
        }
    }
}
