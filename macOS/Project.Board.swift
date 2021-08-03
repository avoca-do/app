import Foundation
import Combine

extension Project {
    final class Board: Collection<Cell, Info> {
        required init?(coder: NSCoder) { nil }
        init(board: Int) {
            super.init()
            let vertical = CGFloat(20)
            let horizontal = CGFloat(20)
            let insetsHorizontal = CGFloat(20)
            let insetsVertical = CGFloat(20)
            let width = CGFloat(250)
            let info = CurrentValueSubject<[[Info]], Never>([])
            
            cloud
                .archive
                .map {
                    $0[0]
                }
                .map {
                    $0
                        .items
                        .enumerated()
                        .map {
                            [.init(id: .column(.board(board), $0.0),
                                  string: .make($0.1.name,
                                                font: .preferredFont(forTextStyle: .title2),
                                                color: .labelColor))]
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
                        .flatMap {
                            $0
                        }
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
                .sink { _ in
                    
                }
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .sink { [weak self] in
                    
                    let result = $0
                        .reduce(into: (items: Set<CollectionItem<Info>>(), size: CGSize(width: horizontal, height: vertical))) {
                            $0.size.height = max($0.size.height, $1
                                                    .reduce(into: vertical) {
                                                        let height = ceil($1.string.height(for: Self.width - Cell.insetsHorizontal2) + Cell.insetsVertical2)
                                                        $0.items.insert(.init(
                                                                            info: $1,
                                                                            rect: .init(
                                                                                x: Self.insets,
                                                                                y: $0.y,
                                                                                width: Self.width,
                                                                                height: height)))
                                                        $0.y += height + 2
                                                    })
                            $0.size.width
                        }
                    
                    self?.items.send(result.items)
                    self?.height.send(result.y + vertical)
                }
                .store(in: &subs)
        }
    }
}
