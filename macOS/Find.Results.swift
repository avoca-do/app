import AppKit
import Combine
import Kanban

extension Find {
    final class Results: Collection<Cell, Info> {
        static let cellWidth = width - Cell.insetsHorizontal2
        private static let width = Find.width - insets2
        private static let insets = CGFloat(20)
        private static let insets2 = insets + insets
        private let select = PassthroughSubject<CGPoint, Never>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            
            let vertical = CGFloat(20)
            let info = PassthroughSubject<[Info], Never>()
            let selected = PassthroughSubject<Info.ID?, Never>()
            
            
            info
                .removeDuplicates()
                .sink {
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
                    self.items.send(result.items)
                    self.size.send(.init(width: 0, height: result.y + vertical))
                }
                .store(in: &subs)
            
            select
                .map { point in
                    self
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
            
//            info
//                .removeDuplicates()
//                .combineLatest(selected
//                                .compactMap {
//                                    $0
//                                })
//                .map { _, selected in
//                    .view(selected)
//                }
//                .subscribe(session.state)
//                .store(in: &subs)
            
//            session
//                .select
//                .subscribe(selected)
//                .store(in: &subs)
            
            render
                .combineLatest(selected
                                .removeDuplicates())
                .sink { _, selected in
                    self
                        .cells
                        .forEach {
                            $0.state = $0.item?.info.id == selected
                                ? .pressed
                                : .none
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
    }
}
