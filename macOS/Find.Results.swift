import AppKit
import Combine
import Kanban

extension Find {
    final class Results: Collection<Cell, Info> {
        static let cellWidth = width - Cell.insetsHorizontal2
        private static let width = Find.width - insets2
        private static let insets = CGFloat(25)
        private static let insets2 = insets + insets
        private let select = PassthroughSubject<CGPoint, Never>()
        
        deinit {
            print("results gone")
        }
        
        required init?(coder: NSCoder) { nil }
        init(found: PassthroughSubject<[Found], Never>, move: PassthroughSubject<(date: Date, direction: Move), Never>) {
            super.init()
            scrollerInsets.bottom = 8
            
            let vertical = CGFloat(15)
            let info = PassthroughSubject<[Info], Never>()
            let selected = PassthroughSubject<Info.ID?, Never>()
            
            found
                .sink { [weak self] _ in
                    self?.contentView.bounds.origin.y = 0
                }
                .store(in: &subs)

            found
                .removeDuplicates()
                .map {
                    $0
                        .enumerated()
                        .map { item in
                            .init(id: item.1.path,
                                  string: .make {
                                    $0.append(.make(item.1.content,
                                                    font: .preferredFont(forTextStyle: .body),
                                                    color: .secondaryLabelColor))
                                    $0.linebreak()
                                    $0.append(.make(item.1.breadcrumbs,
                                                    font: .preferredFont(forTextStyle: .callout),
                                                    color: .tertiaryLabelColor))
                                  },
                                  first: item.0 == 0)
                        }
                }
                .subscribe(info)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .sink { [weak self] in
                    let result = $0
                        .reduce(into: (items: Set<CollectionItem<Info>>(), y: vertical)) {
                            let height = ceil($1.string.height(for: Self.cellWidth) + Cell.insetsVertical2)
                            $0.items.insert(.init(
                                                info: $1,
                                                rect: .init(
                                                    x: Self.insets,
                                                    y: $0.y,
                                                    width: Self.width,
                                                    height: height)))
                            $0.y += height + 2
                        }
                    self?.items.send(result.items)
                    self?.size.send(.init(width: 0, height: result.y + vertical))
                }
                .store(in: &subs)
            
            select
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
                .subscribe(selected)
                .store(in: &subs)
            
            render
                .combineLatest(selected
                                .removeDuplicates())
                .sink { [weak self] _, selected in
                    self?
                        .cells
                        .forEach {
                            $0.state = $0.item?.info.id == selected
                                ? .pressed
                                : .none
                        }
                }
                .store(in: &subs)
            
            move
                .combineLatest(info
                                .removeDuplicates(),
                               highlighted
                                .removeDuplicates())
                .removeDuplicates {
                    $0.0.0 == $1.0.0
                }
                .sink { [weak self] move, info, highlighted in
                    (info
                        .firstIndex {
                            $0.id == highlighted
                        }
                        ?? (info.isEmpty
                            ? nil
                            : move.1 == .down
                                ? info.count - 1
                                : 0))
                        .map { (index: Int) in
                            move.1 == .down
                                ? index < info.count - 1
                                    ? index + 1
                                    : 0
                                : index > 0
                                    ? index - 1
                                    : info.count - 1
                        }
                        .map { index in
                            self?
                                .cells
                                .first {
                                    $0.item?.info.id == info[index].id
                                }
                                .map(\.frame.midY)
                                .map {
                                    self?.center(y: $0)
                                }
                            self?.highlighted.send(info[index].id)
                        }
                }
                .store(in: &subs)
            
            
        }
        
        override func mouseUp(with: NSEvent) {
            switch with.clickCount {
            case 1:
                select.send(point(with: with))
            default:
                break
            }
        }
        
        func center(y: CGFloat) {
            print(y)
            NSAnimationContext
                .runAnimationGroup {
                    $0.duration = 0.3
                    $0.allowsImplicitAnimation = true
                    contentView.bounds.origin.y = y - bounds.midY
                }
        }
    }
}
