import AppKit

extension Project {
    final class Card: NSScrollView {
        override var frame: NSRect {
            didSet {
                (documentView as! Editor).textContainer!.size.width = bounds.width - ((documentView as! Editor).textContainerInset.width * 2)
            }
        }
        
        required init?(coder: NSCoder) { nil }
        init(board: Int) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            hasVerticalScroller = true
            verticalScroller!.controlSize = .mini
            drawsBackground = false
            documentView = Editor()
        }
    }
}
