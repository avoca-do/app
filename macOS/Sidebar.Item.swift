import AppKit

extension Sidebar {
    final class Item: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String, icon: String) {
            super.init()
            wantsLayer = true
            layer!.cornerRadius = 6
            
            let text = Text()
            text.stringValue = title
            text.font = .preferredFont(forTextStyle: .body)
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(text)
            
            let image = NSImageView(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentTintColor = .controlAccentColor
            addSubview(image)
            
            widthAnchor.constraint(equalToConstant: Metrics.sidebar.width - Metrics.sidebar.padding).isActive = true
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 8).isActive = true
            
            image.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            text.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 4).isActive = true
            text.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -4).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .selected:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.2).cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
    }
}
