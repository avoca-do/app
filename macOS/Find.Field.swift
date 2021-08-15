import AppKit

extension Find {
    final class Field: NSTextField {
        required init?(coder: NSCoder) { nil }
        init() {
            Self.cellClass = Cell.self
            super.init(frame: .zero)
            bezelStyle = .roundedBezel
            translatesAutoresizingMaskIntoConstraints = false
            font = .systemFont(ofSize: 18, weight: .regular)
            controlSize = .large
            lineBreakMode = .byTruncatingMiddle
            textColor = .labelColor
            isAutomaticTextCompletionEnabled = false
            placeholderString = "Find"
        }
        
        override var canBecomeKeyView: Bool {
            true
        }
        
        override func viewDidMoveToWindow() {
            window?.initialFirstResponder = self
        }
    }
}
