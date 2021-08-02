import AppKit

final class Text: NSTextField {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        isBezeled = false
        isEditable = false
        setAccessibilityRole(.staticText)
    }
    
    override var acceptsFirstResponder: Bool {
        false
    }
    
    override var canBecomeKeyView: Bool {
        false
    }
    
    override var allowsVibrancy: Bool {
        true
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        nil
    }
    
    override func acceptsFirstMouse(for: NSEvent?) -> Bool {
        false
    }
}
