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
            text.font = .regular()
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(text)
            
            let image = NSImageView(image: NSImage(systemSymbolName: icon, accessibilityDescription: nil)!)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentTintColor = .controlAccentColor
            addSubview(image)
            
            widthAnchor.constraint(equalToConstant: 130).isActive = true
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 6).isActive = true
            
            image.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
            image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            
            text.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 4).isActive = true
            text.topAnchor.constraint(equalTo: topAnchor, constant: 6).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -4).isActive = true
        }
    }
}
