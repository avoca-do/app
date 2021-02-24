import AppKit
import Combine
import Kanban

final class Board: NSScrollView, NSPopoverDelegate {
    private var subs = Set<AnyCancellable>()
    private let drag = PassthroughSubject<CGSize, Never>()
    private let select = PassthroughSubject<CGPoint, Never>()
    private let edit = PassthroughSubject<CGPoint, Never>()
    private let highlight = PassthroughSubject<CGPoint, Never>()
    private let drop = PassthroughSubject<Date, Never>()
    private let clear = PassthroughSubject<Date, Never>()
    private let editing = PassthroughSubject<Bool, Never>()
    
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
        addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .mouseMoved, .activeInActiveApp, .inVisibleRect], owner: self))
        
        var cells = Set<Cell>()
        let items = PassthroughSubject<Set<Item>, Never>()
        let clip = PassthroughSubject<CGRect, Never>()
        let size = PassthroughSubject<CGSize, Never>()
        let selected = PassthroughSubject<Cell?, Never>()
            
        clip.combineLatest(size) {
            .init(width: max($0.width, $1.width), height: max($0.height, $1.height))
        }
        .removeDuplicates()
        .sink {
            content.frame.size = $0
        }
        .store(in: &subs)
        
        items.combineLatest(clip) { items, clip in
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
        
        items
            .combineLatest(selected, drop)
            .filter { _, selected, _ in
                selected != nil
            }.removeDuplicates {
                $0.2 == $1.2
            }.sink { items, cell, _ in
                items.columns.sorted {
                    $0.rect.minX < $1.rect.minX
                }.transform {
                    { column in
                        items.cards.filter {
                            $0.path.column == column.path
                        }.sorted {
                            $0.rect.minY < $1.rect.minY
                        }.filter {
                            $0.rect.midY < cell!.frame.midY
                        }.transform { cards in
                            let path = cell!.item!.path
                            let card = cards.last == nil
                                ? 0
                                : path.column == column.path
                                    ? cards.last!.path._card >= path._card
                                        ? cards.last!.path._card
                                        : cards.last!.path._card + 1
                                    : cards.last!.path._card + 1
                                
                            NSAnimationContext.runAnimationGroup({
                                $0.duration = 0.3
                                $0.allowsImplicitAnimation = true
                                $0.timingFunction = .init(name: .easeInEaseOut)
                                if path == .card(column.path, card) {
                                    cell!.frame.origin = cell!.item!.rect.origin
                                } else {
                                    cell!.frame.origin = .init(
                                        x: column.rect.minX,
                                        y: cards.last?.rect.maxY ?? column.rect.maxY)
                                }
                            }) {
                                Session.mutate {
                                    if path.column == column.path {
                                        $0.move(path, vertical: card)
                                    } else {
                                        $0.move(path, horizontal: column.path._column)
                                        $0.move(.card(column.path, 0), vertical: card)
                                    }
                                }
                            }
                        }
                    } (
                        $0.filter {
                            $0.rect.maxX > cell!.frame.midX
                        }.first ?? $0.last!
                    )
                }
            }.store(in: &subs)
        
        NotificationCenter.default.publisher(for: NSView.boundsDidChangeNotification, object: contentView)
            .merge(with: NotificationCenter.default.publisher(for: NSView.frameDidChangeNotification, object: contentView))
            .compactMap {
                ($0.object as? NSClipView)?.documentVisibleRect
            }
            .debounce(for: .milliseconds(5), scheduler: DispatchQueue.main)
            .sink(receiveValue: clip.send)
            .store(in: &subs)
        
        Session.archiving.sink { archive in
            var set = Set<Item>()
            var rect = CGSize.zero
            (0 ..< archive.count(Session.path.board)).map {
                 (Path.column(Session.path.board, $0), (Metrics.board.spacing * .init($0)) + Metrics.board.horizontal)
            }.forEach { column in
                let item = Item(path: column.0, x: column.1, y: Metrics.board.vertical)
                set.insert(item)
                rect.width = item.rect.maxX + Metrics.board.horizontal
                rect.height = max((0 ..< archive.count(column.0)).map {
                    Path.card(column.0, $0)
                }.reduce(item.rect.maxY) {
                    let item = Item(path: $1, x: column.1, y: $0)
                    set.insert(item)
                    return item.rect.maxY
                } + Metrics.board.vertical, rect.height)
            }
            items.send(set)
            size.send(rect)
        }.store(in: &subs)
        
        highlight
            .combineLatest(selected, editing)
            .filter {
                $1 == nil && !$2
            }.sink { point, _, _ in
                cells.forEach {
                    $0.state = $0.frame.contains(point) ? .highlighted : .none
                }
            }.store(in: &subs)
        
        drag.combineLatest(selected).filter {
            $1 != nil
        }.sink {
            $1!.frame = $1!.frame.offsetBy(dx: $0.width, dy: $0.height)
        }.store(in: &subs)
        
        select.sink { point in
            selected.send(
                cells.cards.first {
                    $0.item!.rect.contains(point)
                }
            )
        }.store(in: &subs)
        
        edit.sink { [weak self] point in
            cells.cards.first {
                $0.item!.rect.contains(point)
            }.map {
                self?.editing.send(true)
                
                let edit = Cell.Edit(path: Session.path)
                edit.delegate = self
                edit.show(relativeTo: $0.bounds, of: $0, preferredEdge: .minY)
                $0.state = .highlighted
            }
        }.store(in: &subs)
        
        clear
            .combineLatest(editing)
            .filter {
                !$1
            }
            .removeDuplicates {
                $0.0 == $1.0
            }
            .sink { _, _ in
                cells.filter{
                    $0.state != .none
                }.forEach {
                    $0.state = .none
                }
            }.store(in: &subs)
        
        drop.delay(for: .milliseconds(100), scheduler: DispatchQueue.main).sink { _ in
            selected.send(nil)
        }.store(in: &subs)
        
        selected.send(nil)
        editing.send(false)
    }
    
    override func mouseExited(with: NSEvent) {
        clear.send(.init())
    }
    
    override func mouseMoved(with: NSEvent) {
        highlight.send(point(with: with))
    }
    
    override func mouseDown(with: NSEvent) {
        Session.edit.send(nil)
        select.send(point(with: with))
    }
    
    override func rightMouseDown(with: NSEvent) {
        Session.edit.send(nil)
        edit.send(point(with: with))
    }
    
    override func mouseDragged(with: NSEvent) {
        drag.send(.init(width: with.deltaX, height: with.deltaY))
    }
    
    override func mouseUp(with: NSEvent) {
        drop.send(.init())
    }
    
    func popoverDidShow(_: Notification) {
        editing.send(true)
    }
    
    func popoverWillClose(_: Notification) {
        editing.send(false)
    }
 
    private func point(with: NSEvent) -> CGPoint {
        documentView!.convert(with.locationInWindow, from: nil)
    }
}
