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
        addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .mouseMoved, .activeInActiveApp, .inVisibleRect], owner: self))
        
        var cells = Set<Cell>()
        
        NotificationCenter.default.publisher(for: NSView.boundsDidChangeNotification, object: contentView)
            .merge(with: NotificationCenter.default.publisher(for: NSView.frameDidChangeNotification, object: contentView))
            .compactMap {
                ($0.object as? NSClipView)?.documentVisibleRect
            }
            .debounce(for: .milliseconds(5), scheduler: DispatchQueue.main)
            .combineLatest(
                Session.archiving
                    .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
                    .map { archive in
                        (0 ..< archive.count(Session.path.board)).map {
                             (Path.column(Session.path.board, $0), (Metrics.board.spacing * .init($0)) + Metrics.board.horizontal)
                        }.reduce(into: (CGSize.zero, Set<Item>())) { set, column in
                            let item = Item(path: column.0, x: column.1, y: Metrics.board.vertical)
                            set.1.insert(item)
                            set.0.width = item.rect.maxX + Metrics.board.horizontal
                            set.0.height = max((0 ..< archive.count(column.0)).map {
                                Path.card(column.0, $0)
                            }.reduce(item.rect.maxY) {
                                let item = Item(path: $1, x: column.1, y: $0)
                                set.1.insert(item)
                                return item.rect.maxY
                            } + Metrics.board.vertical, set.0.height)
                         }
                    }) { clip, set -> Set<Item> in
                content.frame.size.width = max(set.0.width, clip.width)
                content.frame.size.height = max(set.0.height, clip.height)
                return set.1.filter {
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
    
    override func mouseExited(with: NSEvent) {
        cells {
            $0.filter{
                $0.state != .none
            }.forEach {
                $0.state = .none
            }
        }
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
        Session.edit.send(nil)
        point(with: with) { point in
            cells {
                selected = $0.cards.first {
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
            cells { cells in
                cells.columns.sorted {
                    $0.frame.minX < $1.frame.minX
                }.transform {
                    { column in
                        cells.cards.filter {
                            $0.item?.path.column == column.item?.path
                        }.sorted {
                            $0.frame.minY < $1.frame.minY
                        }.filter {
                            $0.frame.midY < selected.frame.midY
                        }.transform { cards in
                            NSAnimationContext.runAnimationGroup({
                                $0.duration = 0.3
                                $0.allowsImplicitAnimation = true
                                $0.timingFunction = .init(name: .easeInEaseOut)
                                selected.frame.origin = .init(
                                    x: column.frame.minX,
                                    y: cards.last?.frame.maxY ?? column.frame.maxY)
                            }) {
                                guard
                                    let path = selected.item?.path,
                                    let column = column.item?.path
                                else { return }
                                let card = (cards.last?.item?.path._card ?? -1) + 1
                                Session.mutate {
                                    if path.column == column {
                                        $0.move(path, vertical: card > path._card ? card - 1 : card)
                                    } else {
                                        $0.move(path, horizontal: column._column)
                                        $0.move(.card(column, 0), vertical: card)
                                    }
                                }
                            }
                        }
                    } ($0.filter {
                        $0.frame.maxX > selected.frame.midX
                    }.first ?? $0.last!)
                    // fix here
                }
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
