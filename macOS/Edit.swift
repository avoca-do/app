import AppKit
import Kanban

final class Edit: NSScrollView {
    override var frame: NSRect {
        didSet {
            (documentView as! Textview).textContainer!.size.width = bounds.width - ((documentView as! Textview).textContainerInset.width * 2)
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init(path: Path) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        drawsBackground = false
        documentView = Textview()
    }
}
