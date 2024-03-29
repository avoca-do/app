import AppKit
import Kanban

extension Edit {
    final class Textview: NSTextView {
        override var canBecomeKeyView: Bool {
            true
        }

        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .init(x: 0, y: 0, width: 0, height: 100_000), textContainer: Container())
            allowsUndo = true
            isRichText = false
            drawsBackground = false
            isContinuousSpellCheckingEnabled = Defaults.spell
            isAutomaticTextCompletionEnabled = Defaults.correction
            insertionPointColor = .labelColor
            typingAttributes[.font] = NSFont.monospacedSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize + 4, weight: .regular)
            typingAttributes[.kern] = 1
            font = typingAttributes[.font] as? NSFont
            selectedTextAttributes = [.backgroundColor: NSColor.quaternaryLabelColor, .foregroundColor: NSColor.labelColor]
            isVerticallyResizable = true
            isHorizontallyResizable = true
            textContainerInset.width = 40
            textContainerInset.height = 20
        }
        
        deinit {
            NSApp
                .windows
                .forEach {
                    $0.undoManager?.removeAllActions()
                }
        }
        
        override func cancelOperation(_ sender: Any?) {
            guard string.isEmpty else {
                window?.makeFirstResponder(nil)
                return
            }
            session.cancel()
        }
        
        override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn: Bool) {
            var rect = rect
            rect.size.width = 2
            super.drawInsertionPoint(in: rect, color: color, turnedOn: turnedOn)
        }
        
        override func setNeedsDisplay(_ rect: NSRect, avoidAdditionalLayout: Bool) {
            var rect = rect
            rect.size.width += 1
            super.setNeedsDisplay(rect, avoidAdditionalLayout: avoidAdditionalLayout)
        }
        
        override func didChangeText() {
            super.didChangeText()
            layoutManager!.ensureLayout(for: textContainer!)
            setNeedsDisplay(bounds)
            session.text.send(string)
        }
        
        override func keyDown(with: NSEvent) {
            switch with.keyCode {
            case 36:
                if with.modifierFlags.intersection(.deviceIndependentFlagsMask) == .command {
                    switch session.state.value {
                    case .create, .column, .card:
                        session.add()
                    case .edit:
                        session.save()
                    default:
                        break
                    }
                } else {
                    super.keyDown(with: with)
                }
            default: super.keyDown(with: with)
            }
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
