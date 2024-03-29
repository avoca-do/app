import AppKit
import Combine

class Collection<Cell, Info>: NSScrollView where Cell : CollectionCell<Info> {
    var selected = Set<Info.ID>() {
        didSet {
            cells
                .forEach { cell in
                    cell.state = selected.contains { $0 == cell.item?.info.id } ? .pressed : .none
                }
        }
    }
    
    var highlighted: Info.ID? = nil {
        didSet {
            if let highlighted = highlighted {
                cells
                    .filter {
                        $0.state != .pressed && $0.state != .dragging
                    }
                    .forEach {
                        $0.state = $0.item?.info.id == highlighted ? .highlighted : .none
                    }
            } else {
                cells
                    .filter {
                        $0.state == .highlighted
                    }
                    .forEach {
                        $0.state = .none
                    }
            }
        }
    }
    
    final var subs = Set<AnyCancellable>()
    final var cells = Set<Cell>()
    final let render = PassthroughSubject<Void, Never>()
    final let items = PassthroughSubject<Set<CollectionItem<Info>>, Never>()
    final let size = PassthroughSubject<CGSize, Never>()
    private let highlight = PassthroughSubject<CGPoint, Never>()

    required init?(coder: NSCoder) { nil }
    init(active: NSTrackingArea.Options) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        let content = Flip()
        content.layer = Layer()
        content.wantsLayer = true
        documentView = content
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        drawsBackground = false
        contentView.postsBoundsChangedNotifications = true
        contentView.postsFrameChangedNotifications = true
        addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .mouseMoved, active, .inVisibleRect], owner: self))
        
        let clip = PassthroughSubject<CGRect, Never>()
        clip
            .combineLatest(size) {
                .init(width: max($0.width, $1.width), height: max($0.height, $1.height))
            }
            .removeDuplicates()
            .sink {
                content.frame.size = $0
            }
            .store(in: &subs)

        items
            .combineLatest(clip
                            .removeDuplicates()) { items, clip in
                items
                    .filter {
                        clip.intersects($0.rect)
                    }
            }
            .removeDuplicates()
            .sink { [weak self] visible in
                guard let selected = self?.selected else { return }
                
                self?
                    .cells
                    .filter {
                        $0.item != nil
                    }
                    .filter { cell in
                        !visible
                            .contains {
                                $0.info.id == cell.item?.info.id
                            }
                    }
                    .forEach {
                        $0.removeFromSuperlayer()
                        $0.item = nil
                    }
                
                visible
                    .forEach { item in
                        let cell = self?
                            .cells
                            .first {
                                $0.item?.info.id == item.info.id
                            }
                            ?? self?.cells.first {
                                $0.item == nil
                            }
                            ?? {
                                self?.cells.insert($0)
                                return $0
                            } (Cell())
                        cell.state = selected.contains(item.info.id) ? .pressed : .none
                        cell.item = item
                        content.layer!.addSublayer(cell)
                    }
                
                self?.render.send()
            }
            .store(in: &subs)
        
        NotificationCenter
            .default
            .publisher(for: NSView.boundsDidChangeNotification)
            .merge(with: NotificationCenter
                    .default
                    .publisher(for: NSView.frameDidChangeNotification))
            .compactMap {
                $0.object as? NSClipView
            }
            .filter { [weak self] in
                $0 == self?.contentView
            }
            .map {
                $0.documentVisibleRect
            }
            .subscribe(clip)
            .store(in: &subs)
        
        highlight
            .filter { [weak self] _ in
                self?.highlighted != nil
            }
            .map { [weak self] point in
                self?
                    .cells
                    .first {
                        $0
                            .item
                            .map {
                                $0
                                    .rect
                                    .contains(point)
                            }
                        ?? false
                    }
            }
            .filter { $0 == nil }
            .sink { [weak self] _ in
                self?.highlighted = nil
            }
            .store(in: &subs)
        
        highlight
            .compactMap { [weak self] point in
                self?
                    .cells
                    .first {
                        $0
                            .item
                            .map {
                                $0
                                    .rect
                                    .contains(point)
                            }
                        ?? false
                    }
            }
            .sink { [weak self] in
                guard let id = $0.item?.info.id else { return }
                self?.highlighted = id
            }
            .store(in: &subs)
    }
    
    final func cell(at point: CGPoint) -> Cell? {
        cells
            .first {
                $0
                    .item
                    .map {
                        $0
                            .rect
                            .contains(point)
                    }
                ?? false
            }
    }
    
    final override func mouseExited(with: NSEvent) {
        guard highlighted != nil else { return }
        highlighted = nil
    }
    
    final override func mouseMoved(with: NSEvent) {
        highlight.send(point(with: with))
    }
    
    final override func mouseDown(with: NSEvent) {
        guard with.clickCount == 1 else { return }
        window?.makeFirstResponder(self)
    }
    
    final override func rightMouseDown(with: NSEvent) {
        highlight.send(point(with: with))
        super.rightMouseDown(with: with)
    }
    
    final func point(with: NSEvent) -> CGPoint {
        documentView!.convert(with.locationInWindow, from: nil)
    }
    
    final override var allowsVibrancy: Bool {
        true
    }
}
