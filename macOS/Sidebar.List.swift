import AppKit
import Combine

extension Sidebar {
    final class List: Collection<Cell, Info> {
        static let width = Sidebar.width - insets2
        private static let insets = CGFloat(20)
        private static let insets2 = insets + insets
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            let top = CGFloat(10)
            let bottom = CGFloat(20)
            let info = CurrentValueSubject<[Info], Never>([])
            
            cloud
                .archive
                .map {
                    $0
                        .items
                        .map {
                            (name: $0.name, modified: $0.date)
                        }
                }
                .map{
                    $0
                        .enumerated()
                        .map { item in
                            .init(id: item.0,
                                  string: .make {
                                    $0.append(.make(item.1.name,
                                                    font: .preferredFont(forTextStyle: .title3),
                                                    color: .labelColor))
                                    $0.linebreak()
                                    $0.append(.make(RelativeDateTimeFormatter().string(from: item.1.modified),
                                                    font: .preferredFont(forTextStyle: .callout),
                                                    color: .secondaryLabelColor))
                                  })
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
                        .reduce(into: (items: Set<CollectionItem<Info>>(), y: top)) {
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
                    self?.first.send($0.first?.id)
                    self?.items.send(result.items)
                    self?.height.send(result.y + bottom)
                }
                .store(in: &subs)
        }
    }
}
