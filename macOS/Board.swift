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
    private let items = PassthroughSubject<[Path : Item], Never>()
    private let clip = PassthroughSubject<CGRect, Never>()
    
    
    
    
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let content = Flip()
        translatesAutoresizingMaskIntoConstraints = false
        documentView = content
        hasVerticalScroller = true
        hasHorizontalScroller = true
        verticalScroller!.controlSize = .mini
        horizontalScroller!.controlSize = .mini
        contentView.postsBoundsChangedNotifications = true
        drawsBackground = false
        
        Session.shared.archive.sink { [weak self] archive in
            content.frame.size.height = self?.frame.size.height ?? 0
            self?.items.send((0 ..< archive.count(Session.shared.path.value.board)).map {
                 (Path.column(Session.shared.path.value.board, $0),
                  ((Metrics.board.item.size.width + (Metrics.board.item.padding * 2)) * .init($0)) + Metrics.board.item.padding)
             }.reduce(into: [Path : Item]()) { map, column in
                map[column.0] = .init(path: column.0, x: column.1, y: Metrics.board.item.padding)
                content.frame.size.width = map[column.0]!.rect.maxX + Metrics.board.item.padding
                content.frame.size.height = max((0 ..< archive.count(column.0)).map {
                    Path.card(column.0, $0)
                }.reduce(map[column.0]!.rect.maxY) {
                    map[$1] = Item(path: $1, x: column.1, y: $0 + Metrics.board.item.padding)
                    return map[$1]!.rect.maxY
                }, content.frame.size.height)
             })
        }.store(in: &subs)
        
        NotificationCenter.default.publisher(for: NSView.boundsDidChangeNotification, object: contentView).sink { [weak self] _ in
            self?.clip.send(self?.contentView.bounds ?? .zero)
        }.store(in: &subs)
        
        items.combineLatest(clip) { items, clip in
            
        }
        
        /*
        
        (NSApp as! App).pages.combineLatest(browser.search).sink { [weak self] in
            self?.map.pages = ({ pages, search in
                search.isEmpty ? pages : pages.filter {
                    $0.title.localizedCaseInsensitiveContains(search)
                        || $0.url.absoluteString.localizedCaseInsensitiveContains(search)
                }
            } ($0.0, $0.1.trimmingCharacters(in: .whitespacesAndNewlines))).map(Map.Page.init(page:))
        }.store(in: &subs)
        
        map.items.sink { [weak self] items in
            guard let self = self else { return }
            self.cells
                .filter { $0.page != nil }
                .filter { cell in !items.contains { $0.page.page == cell.page?.page } }
                .forEach {
                    $0.removeFromSuperview()
                    $0.page = nil
                }
            items.forEach { item in
                let cell = self.cells.first { $0.page?.page == item.page.page } ?? self.cells.first { $0.page == nil } ?? {
                    self.cells.insert($0)
                    return $0
                } (Cell())
                cell.page = item.page
                cell.frame = item.frame
                self.documentView!.addSubview(cell)
            }
        }.store(in: &subs)
        
        map.height.sink { [weak self] in
            guard let frame = self?.frame else { return }
            content.frame.size.height = max($0, frame.size.height)
        }.store(in: &subs)
        
        browser.search.send("")
        */
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
