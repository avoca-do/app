import AppKit
import Kanban

extension Edit {
    final class Textview: NSTextView {
//        var write: Write? {
//            didSet {
////                if let write = write {
////                    switch write {
////                    case .new:
////                        string = ""
////                    case let .edit(path):
////                        switch path {
////                        case .card:
////                            string = Session.archive[content: path]
////                        default: break
////                        }
////                    }
////                } else {
////                    string = ""
////                }
//            }
//        }
//        
        override var canBecomeKeyView: Bool { true }
        
        override func cancelOperation(_: Any?) {
            window?.makeFirstResponder(nil)
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
        
        override final func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn: Bool) {
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
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
