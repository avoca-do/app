import AppKit

extension Find {
    final class Option: Control {
        private weak var image: Image!
        
        required init?(coder: NSCoder) { nil }
        init(icon: String) {
            let image = Image(icon: icon)
            image.symbolConfiguration = .init(pointSize: 15, weight: .regular)
            self.image = image
            
            super.init(layer: false)
            
            addSubview(image)
            widthAnchor.constraint(equalToConstant: 28).isActive = true
            heightAnchor.constraint(equalTo: widthAnchor).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        override func updateLayer() {
            super.updateLayer()
            
            switch state {
            case .off:
                image.contentTintColor = .quaternaryLabelColor
            case .highlighted, .pressed:
                image.contentTintColor = .labelColor
            default:
                image.contentTintColor = .secondaryLabelColor
            }
        }
    }
}
