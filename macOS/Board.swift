import AppKit
import Combine
import Kanban

final class Board: NSScrollView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let content = Flip()
        documentView = content
        hasVerticalScroller = true
        hasHorizontalScroller = true
        verticalScroller!.controlSize = .mini
        horizontalScroller!.controlSize = .mini
        postsFrameChangedNotifications = true
        contentView.postsBoundsChangedNotifications = true
        contentView.postsFrameChangedNotifications = true
        drawsBackground = false
        
        var cells = Set<Cell>()
        
        NotificationCenter.default.publisher(for: NSView.boundsDidChangeNotification, object: contentView)
            .merge(with: NotificationCenter.default.publisher(for: NSView.frameDidChangeNotification, object: contentView))
            .compactMap {
                ($0.object as? NSClipView)?.documentVisibleRect
            }
            .debounce(for: .milliseconds(5), scheduler: DispatchQueue.main)
            .combineLatest(Session.archiving
                            .map { archive in
                                (0 ..< archive.count(Session.path.board)).map {
                                     (Path.column(Session.path.board, $0),
                                      ((Metrics.board.item.size.width + Metrics.board.item.padding2 + Metrics.board.column.horizontal) * .init($0)) + Metrics.board.horizontal)
                                 }.reduce(into: Set<Item>()) { set, column in
                                    let item = Item(path: column.0, x: column.1, y: Metrics.board.vertical)
                                    set.insert(item)
                                    content.frame.size.width = item.rect.maxX + Metrics.board.horizontal
                                    content.frame.size.height = max((0 ..< archive.count(column.0)).map {
                                        Path.card(column.0, $0)
                                    }.reduce(item.rect.maxY) {
                                        let item = Item(path: $1, x: column.1, y: $0)
                                        set.insert(item)
                                        return item.rect.maxY
                                    } + Metrics.board.vertical, column.0._column == 0 ? 0 : content.frame.size.height)
                                 }
                            }) { (clip, items: Set<Item>) in
                                items.filter {
                                    clip.intersects($0.rect)
                                }
                            }
                            .removeDuplicates()
                            .sink { items in
                                cells
                                    .filter { $0.item != nil }
                                    .filter { cell in !items.contains { $0 == cell.item } }
                                    .forEach {
                                        $0.removeFromSuperview()
                                        $0.item = nil
                                    }
                                items.forEach { item in
                                    let cell = cells.first { $0.item == item } ?? cells.first { $0.item == nil } ?? {
                                        cells.insert($0)
                                        return $0
                                    } (Cell())
                                    cell.item = item
                                    content.addSubview(cell)
                                }
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
