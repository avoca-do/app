import AppKit

extension Store {
    final class Error: NSVisualEffectView {
        required init?(coder: NSCoder) { nil }
        init(message: String) {
            super.init(frame: .zero)
            state = .active
            
            let text = Text(vibrancy: true)
            text.stringValue = message
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            text.textColor = .secondaryLabelColor
            text.font = .preferredFont(forTextStyle: .title3)
            addSubview(text)
            
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 50).isActive = true
            text.rightAnchor.constraint(equalTo: rightAnchor, constant: -50).isActive = true
            text.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        }
    }
}
