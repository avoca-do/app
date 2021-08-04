import AppKit
import Kanban

final class Edit: NSScrollView {
    override var frame: NSRect {
        didSet {
            textview.textContainer!.size.width = bounds.width - (textview.textContainerInset.width * 2)
        }
    }
    
    override func viewDidMoveToWindow() {
        window?.makeFirstResponder(textview)
    }
    
    private weak var textview: Textview!
    
    required init?(coder: NSCoder) { nil }
    init(state: State) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        drawsBackground = false
        
        let textview = Textview()
        documentView = textview
        self.textview = textview
        
        if case let .edit(path) = state {
            switch path {
            case .column:
                textview.string = cloud.archive.value[path.board][path.column].name
            case .card:
                textview.string = cloud.archive.value[path.board][path.column][path.card].content
            default:
                break
            }
        }
    }
}
