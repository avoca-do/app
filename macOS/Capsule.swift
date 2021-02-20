import AppKit

final class Capsule: Control {
    private(set) weak var text: Text!
    
    required init?(coder: NSCoder) { nil }
    init(title: String) {
        super.init()
        wantsLayer = true
        layer!.cornerRadius = 14
        
        let text = Text()
        text.stringValue = title
        text.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .callout).pointSize, weight: .medium)
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(text)
        self.text = text
        
        heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        text.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 28).isActive = true
        text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -28).isActive = true
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    override func update() {
        switch state {
        case .highlighted:
            alphaValue = 0.9
        case .pressed:
            alphaValue = 0.7
        default:
            alphaValue = 1
        }
    }
}
