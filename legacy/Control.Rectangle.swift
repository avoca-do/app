import AppKit

extension Control {
    final class Rectangle: Control {
        private(set) weak var text: Text!
        
        required init?(coder: NSCoder) { nil }
        init(title: String) {
            super.init()
            wantsLayer = true
            layer!.cornerRadius = Metrics.corners
            
            let text = Text()
            text.stringValue = title
            text.lineBreakMode = .byTruncatingTail
            text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize, weight: .medium)
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            text.maximumNumberOfLines = 1
            addSubview(text)
            self.text = text
            
            heightAnchor.constraint(equalToConstant: 32).isActive = true
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            text.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 10).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10).isActive = true
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .highlighted:
                alphaValue = 0.8
            case .pressed:
                alphaValue = 0.6
            default:
                alphaValue = 1
            }
        }
    }
}
