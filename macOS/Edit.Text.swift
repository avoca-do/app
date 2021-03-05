import AppKit
import Kanban

extension Edit {
    final class Text: NSTextView {
        var write: Write? {
            didSet {
                if let write = write {
                    switch write {
                    case .new:
                        string = ""
                    case let .edit(path):
                        switch path {
                        case .card:
                            string = Session.archive[content: path]
                        default: break
                        }
                    }
                } else {
                    string = ""
                }
            }
        }
        
        override var canBecomeKeyView: Bool { true }
        private let caret = CGFloat(3)
        
        override func cancelOperation(_ sender: Any?) {
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
        
        @objc func send() {
            let content = string.trimmingCharacters(in: .whitespacesAndNewlines)
            if !content.isEmpty, let write = self.write {
                switch write {
                case let .new(path):
                    switch path {
                    case .board:
                        Session.mutate {
                            $0.card(path)
                            $0[content: .card(.column(path, 0), 0)] = content
                        }
                    default: break
                    }
                case let .edit(path):
                    switch path {
                    case .card:
                        Session.mutate {
                            $0[content: path] = content
                        }
                    default: break
                    }
                }
            }
            cancel()
        }
        
        func cancel() {
            window?.makeFirstResponder(nil)
            Session.edit.send(nil)
        }
    }
}
