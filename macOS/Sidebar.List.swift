import Foundation
import Combine

extension Sidebar {
    final class List: Collection<Cell, Info> {
        static let width = Sidebar.width - insets2
        private static let insets = CGFloat(20)
        private static let insets2 = insets + insets
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            let vertical = CGFloat(20)
            let info = CurrentValueSubject<[Info], Never>([])
            
            cloud
                .archive
                .map {
                    $0
                        .items
                        .map {
                            (name: $0.name, modified: RelativeDateTimeFormatter().string(from: $0.date))
                        }
                }
                .map {
                    $0
                        .enumerated()
                        .map { item in
                            .init(id: item.0,
                                  string: .make {
                                    $0.append(.make(item.1.name,
                                                    font: .preferredFont(forTextStyle: .title3),
                                                    color: .secondaryLabelColor))
                                    $0.linebreak()
                                    $0.append(.make(item.1.modified,
                                                    font: .preferredFont(forTextStyle: .footnote),
                                                    color: .secondaryLabelColor))
                                  },
                                  stringHighlighted: .make {
                                    $0.append(.make(item.1.name,
                                                    font: .preferredFont(forTextStyle: .title3),
                                                    color: .labelColor))
                                    $0.linebreak()
                                    $0.append(.make(item.1.modified,
                                                    font: .preferredFont(forTextStyle: .footnote),
                                                    color: .secondaryLabelColor))
                                  },
                                  first: item.0 == 0)
                        }
                }
                .subscribe(info)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .combineLatest(selected
                                .compactMap {
                                    $0
                                }
                                .removeDuplicates())
                .map { info, selected in
                    info
                        .contains {
                            $0.id == selected
                        } ? selected : nil
                }
                .sink { [weak self] in
                    self?.selected.send($0)
                }
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .combineLatest(selected
                                .compactMap {
                                    $0
                                }
                                .removeDuplicates())
                .map { info, selected in
                    .board(selected)
                }
                .subscribe(session.path)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .sink { [weak self] in
                    let result = $0
                        .reduce(into: (items: Set<CollectionItem<Info>>(), y: vertical)) {
                            let height = ceil($1.string.height(for: Self.width - Cell.insetsHorizontal2) + Cell.insetsVertical2)
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
        }
    }
}
