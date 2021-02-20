import AppKit
import Combine
import Kanban

final class Board: NSScrollView {
    override var frame: NSRect {
        didSet {
            clip.send(contentView.bounds)
        }
    }
    
    private var cells = Set<Cell>()
    private var subs = Set<AnyCancellable>()
    private let items = PassthroughSubject<Set<Item>, Never>()
    private let clip = PassthroughSubject<CGRect, Never>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let content = Flip()
        translatesAutoresizingMaskIntoConstraints = false
        documentView = content
        hasVerticalScroller = true
        hasHorizontalScroller = true
        verticalScroller!.controlSize = .mini
        horizontalScroller!.controlSize = .mini
        contentView.postsBoundsChangedNotifications = true
        drawsBackground = false
        
        items.combineLatest(clip) { items, clip in
            items.filter {
                $0.rect.maxY > clip.minY && $0.rect.minY < clip.maxY
            }
        }.removeDuplicates().sink { [weak self] items in
            guard let self = self else { return }
            self.cells
                .filter { $0.item != nil }
                .filter { cell in !items.contains { $0 == cell.item } }
                .forEach {
                    $0.removeFromSuperview()
                    $0.item = nil
                }
            items.forEach { item in
                let cell = self.cells.first { $0.item == item } ?? self.cells.first { $0.item == nil } ?? {
                    self.cells.insert($0)
                    return $0
                } (Cell())
                cell.item = item
                content.addSubview(cell)
            }
        }.store(in: &subs)
        
        NotificationCenter.default.publisher(for: NSView.boundsDidChangeNotification, object: contentView).sink { [weak self] _ in
            self?.clip.send(self?.contentView.bounds ?? .zero)
        }.store(in: &subs)
        
        Session.archiving.sink { [weak self] archive in
            content.frame.size.height = self?.frame.size.height ?? 0
            self?.items.send((0 ..< archive.count(Session.path.board)).map {
                 (Path.column(Session.path.board, $0),
                  ((Metrics.board.item.size.width + Metrics.board.item.padding2 + Metrics.board.column.horizontal) * .init($0)) + Metrics.board.horizontal)
             }.reduce(into: []) { set, column in
                let item = Item(path: column.0, x: column.1, y: Metrics.board.vertical)
                set.insert(item)
                content.frame.size.width = item.rect.maxX + Metrics.board.horizontal
                content.frame.size.height = max((0 ..< archive.count(column.0)).map {
                    Path.card(column.0, $0)
                }.reduce(item.rect.maxY) {
                    let item = Item(path: $1, x: column.1, y: $0)
                    set.insert(item)
                    return item.rect.maxY
                } + Metrics.board.vertical, content.frame.size.height)
             })
        }.store(in: &subs)
    }
    
    override func mouseDown(with: NSEvent) {
        super.mouseDown(with: with)
        window?.makeFirstResponder(self)
    }
    
    override func mouseUp(with: NSEvent) {
//        guard var page = map.page(for: documentView!.convert(with.locationInWindow, from: nil))?.page else { return }
//        page.date = .init()
//        browser.page.value = page
//        browser.browse.send(page.url)
    }
}
