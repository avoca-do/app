import AppKit

extension Control {
    final class Tool: Control {
        required init?(coder: NSCoder) { nil }
        init(title: String, icon: String) {
            super.init()
            wantsLayer = true
            layer!.cornerRadius = 8
            
            let text = Text()
            text.stringValue = title
            text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium)
            addSubview(text)
            
            let icon = NSImageView(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.contentTintColor = .labelColor
            addSubview(icon)
            
            heightAnchor.constraint(equalToConstant: 36).isActive = true
            
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            icon.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
            icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            update()
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
            case .pressed:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.3).cgColor
            default:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            }
        }
    }

}
