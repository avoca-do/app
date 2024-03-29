import AppKit
import Combine
import Kanban

final class Project: Collection<Project.Cell, Project.Info>, NSMenuDelegate {
    private weak var dragging: Cell?
    private let double = PassthroughSubject<CGPoint, Never>()
    private let drag = PassthroughSubject<(date: Date, size: CGSize), Never>()
    private let drop = PassthroughSubject<Date, Never>()
    
    required init?(coder: NSCoder) { nil }
    init(board: Int) {
        super.init(active: .activeInKeyWindow)
        hasHorizontalScroller = true
        horizontalScroller!.controlSize = .mini
        wantsLayer = true
        menu = .init()
        menu!.delegate = self
        
        let vertical = CGFloat(20)
        let horizontal = CGFloat(50)
        let insetsHorizontal = CGFloat(80)
        let insetsVertical = CGFloat(5)
        let width = CGFloat(300)
        let textWidth = width - Cell.horizontal
        let info = PassthroughSubject<[[Info]], Never>()
        
        drop
            .combineLatest(items)
            .removeDuplicates {
                $0.0 == $1.0
            }
            .compactMap { [weak self] _, items in
                self?
                    .dragging
                    .flatMap { dragging in
                        dragging
                            .item
                            .flatMap { item in
                                {
                                    (cell: dragging, column: $0.0, card: $0.1, point: $0.2)
                                } (items
                                    .drop(cell: item, position: .init(x: dragging.frame.midX, y: dragging.frame.midY)))
                            }
                    }
            }
            .sink { cell, column, card, point in
                cell.position = point
                cell.add({
                    $0.duration = 0.3
                    $0.timingFunction = .init(name: .easeInEaseOut)
                    return $0
                } (CABasicAnimation(keyPath: "position")), forKey: "position")

                DispatchQueue
                    .main
                    .asyncAfter(deadline: .now() + 0.35) { [weak self] in
                        let id = cell.item!.info.id
                        self?.dragging = nil
                        cell.state = .none
                        if id.column != column
                            || id.card != card {
                            cell.item = nil
                            cell.removeFromSuperlayer()
                        }
                        
                        cloud.move(
                            board: board,
                            column: id.column,
                            card: id.card,
                            horizontal: column,
                            vertical: card)
                    }
            }
            .store(in: &subs)
        
        cloud
            .archive
            .map {
                $0[board]
            }
            .map {
                $0
                    .items
                    .enumerated()
                    .map { column in
                        [.init(id: .column(.board(board), column.0),
                              string: .make(column.1.name,
                                            font: .preferredFont(forTextStyle: .title2),
                                            color: .labelColor,
                                            kern: 1))]
                            + column
                            .1
                            .items
                            .enumerated()
                            .map {
                                .init(id: .card(.column(.board(board), column.0), $0.0),
                                      string: .make($0.1.content,
                                                    font: .preferredFont(forTextStyle: .body),
                                                    color: .labelColor,
                                                    kern: 1))
                            }
                    }
            }
            .subscribe(info)
            .store(in: &subs)
        
        info
            .removeDuplicates()
            .sink { [weak self] all in
                let result = all
                    .reduce(into: (items: Set<CollectionItem<Info>>(), size: CGSize(width: horizontal, height: vertical))) { result, column in
                        result.size.height = max(
                            column
                                .reduce(into: vertical) {
                                    let height = ceil($1.string.height(for: textWidth) + Cell.vertical)
                                    result.items.insert(.init(
                                                            info: $1,
                                                            rect: .init(
                                                                x: result.size.width,
                                                                y: $0,
                                                                width: width,
                                                                height: height)))
                                    $0 += height
                                    if $1 != column.last {
                                        $0 += insetsVertical
                                    }
                                },
                            result.size.height)
                        result.size.width += width
                        if column != all.last {
                            result.size.width += insetsHorizontal
                        }
                    }

                self?.items.send(result.items)
                self?.size.send(.init(width: result.size.width + horizontal,
                                      height: result.size.height + vertical))
            }
            .store(in: &subs)
        
        double
            .map { [weak self] point in
                self?
                    .cells
                    .compactMap(\.item)
                    .first {
                        $0.rect.contains(point)
                    }
            }
            .compactMap {
                $0?.info.id
            }
            .map {
                .edit($0)
            }
            .subscribe(session
                        .state)
            .store(in: &subs)
        
        drag
            .removeDuplicates {
                $0.0 == $1.0
            }
            .compactMap { [weak self] _ in
                self?.highlighted
            }
            .filter {
                if case .card = $0 {
                    return true
                }
                return false
            }
            .compactMap { [weak self] highlighted in
                self?
                    .cells
                    .first {
                        $0.item?.info.id == highlighted
                    }
            }
            .sink { [weak self] in
                self?.highlighted = nil
                $0.state = .dragging
                self?.dragging = $0
            }
            .store(in: &subs)
        
        drag
            .sink { [weak self] in
                guard let dragging = self?.dragging else { return }
                dragging.frame = dragging.frame.offsetBy(dx: $0.1.width, dy: $0.1.height)
            }
            .store(in: &subs)
        
        cloud
            .archive
            .debounce(for: .seconds(5), scheduler: DispatchQueue.main)
            .map {
                $0[board].total
            }
            .filter {
                $0 == 0
            }
            .map { _ in
                
            }
            .sink {
                guard case .view = session.state.value else { return }
                session.state.send(.empty(board))
            }
            .store(in: &subs)
    }
    
    override func mouseUp(with: NSEvent) {
        switch with.clickCount {
        case 2:
            double.send(point(with: with))
        default:
            drop.send(.init())
        }
    }
    
    override func mouseDragged(with: NSEvent) {
        drag.send((date: .init(), size: .init(width: with.deltaX, height: with.deltaY)))
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        menu.items = highlighted == nil
            ? []
            : [
                .child("Edit", #selector(edit)) {
                    $0.target = self
                    $0.image = .init(systemSymbolName: "slider.horizontal.3", accessibilityDescription: nil)
                },
                .separator(),
                .child("Delete", #selector(delete)) {
                    $0.target = self
                    $0.image = .init(systemSymbolName: "trash", accessibilityDescription: nil)
                }]
    }
    
    @objc private func edit() {
        highlighted
            .map(State.edit)
            .map(session
                    .state
                    .send)
    }
    
    @objc private func delete() {
        highlighted
            .map(NSAlert.delete(path:))
    }
}
