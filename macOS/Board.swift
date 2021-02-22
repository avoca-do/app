import AppKit
import Combine
import Kanban

final class Board: NSScrollView {
    private var subs = Set<AnyCancellable>()
    
    private weak var selected: Cell? {
        didSet {
            selected?.state = .selected
            oldValue?.state = .none
        }
    }
    
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
        addTrackingArea(.init(rect: .zero, options: [.mouseMoved, .activeInActiveApp, .inVisibleRect], owner: self))
        
        var cells = Set<Cell>()
        
        NotificationCenter.default.publisher(for: NSView.boundsDidChangeNotification, object: contentView)
            .merge(with: NotificationCenter.default.publisher(for: NSView.frameDidChangeNotification, object: contentView))
            .compactMap {
                ($0.object as? NSClipView)?.documentVisibleRect
            }
            .debounce(for: .milliseconds(5), scheduler: DispatchQueue.main)
            .combineLatest(
                Session.archiving
                    .map { archive in
                        (0 ..< archive.count(Session.path.board)).map {
                             (Path.column(Session.path.board, $0), (Metrics.board.spacing * .init($0)) + Metrics.board.horizontal)
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
                            } + Metrics.board.vertical, content.frame.size.height)
                         }
                    }) { clip, items -> Set<Item> in
                        content.frame.size.width = max(content.frame.width, clip.width)
                        content.frame.size.height = max(content.frame.height, clip.height)
                        return items.filter {
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
    
    override func mouseMoved(with: NSEvent) {
        guard selected == nil else { return }
        point(with: with) { point in
            cells {
                $0.forEach {
                    $0.state = $0.frame.contains(point) ? .highlighted : .none
                }
            }
        }
    }
    
    override func mouseDown(with: NSEvent) {
        point(with: with) { point in
            cells {
                selected = $0.filter {
                    if case .column = $0.item!.path {
                        return false
                    }
                    return true
                }
                .first {
                    $0.item!.rect.contains(point)
                }
            }
        }
    }
    
    override func mouseDragged(with: NSEvent) {
        selected.map {
            $0.frame = $0.frame.offsetBy(dx: with.deltaX, dy: with.deltaY)
        }
    }
    
    override func mouseUp(with: NSEvent) {
        selected.map { selected in
            NSAnimationContext.runAnimationGroup {
                $0.duration = 0.3
                $0.allowsImplicitAnimation = true
                selected.frame = selected.item!.rect
            }
        }
        selected = nil
    }
    
    private func cells(transform: ([Cell]) -> Void) {
        transform(documentView!.subviews.compactMap { $0 as? Cell })
    }
    
    private func point(with: NSEvent, transform: (CGPoint) -> Void) {
        transform(documentView!.convert(with.locationInWindow, from: nil))
    }
}
