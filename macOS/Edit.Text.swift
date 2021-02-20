import AppKit
import Kanban

extension Edit {
    final class Text: NSTextView {
        override var canBecomeKeyView: Bool { true }
        private let caret = CGFloat(3)

        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .init(x: 0, y: 0, width: 0, height: 100_000), textContainer: Container())
            allowsUndo = true
            isRichText = false
            drawsBackground = false
            isContinuousSpellCheckingEnabled = Defaults.spell
            isAutomaticTextCompletionEnabled = Defaults.correction
            insertionPointColor = .controlAccentColor
            typingAttributes[.font] = NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize + 3, weight: .medium)
            font = .monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize + 3, weight: .medium)
            selectedTextAttributes = [.backgroundColor: NSColor.controlAccentColor, .foregroundColor: NSColor.black]
            isVerticallyResizable = true
            isHorizontallyResizable = true
            textContainerInset.width = Metrics.edit.horizontal
            textContainerInset.height = Metrics.edit.vertical
        }
        
        override final func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn: Bool) {
            var rect = rect
            rect.size.width = caret
            super.drawInsertionPoint(in: rect, color: color, turnedOn: turnedOn)
        }
        
        override func setNeedsDisplay(_ rect: NSRect, avoidAdditionalLayout: Bool) {
            var rect = rect
            rect.size.width += caret
            super.setNeedsDisplay(rect, avoidAdditionalLayout: avoidAdditionalLayout)
        }
        
        override func didChangeText() {
            super.didChangeText()
            layoutManager!.ensureLayout(for: textContainer!)
        }
    }
}
