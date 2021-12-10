import AppKit
import Combine
import Kanban

extension Sidebar {
    final class List: Collection<Cell, Info>, NSMenuDelegate {
        static let cellWidth = width - Cell.insetsHorizontal2
        private static let width = Sidebar.width - insets2
        private static let insets = CGFloat(15)
        private static let insets2 = insets + insets
        private let select = PassthroughSubject<CGPoint, Never>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            menu = .init()
            menu!.delegate = self
            
            let vertical = CGFloat(20)
            let info = PassthroughSubject<[Info], Never>()
            let selected = PassthroughSubject<Info.ID?, Never>()
            
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
                                                    color: .tertiaryLabelColor))
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
            
            selected
                .compactMap {
                    $0
                }
                .map(State.view)
                .subscribe(session.state)
                .store(in: &subs)
            
            session
                .select
                .subscribe(selected)
                .store(in: &subs)
            
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
        
        func menuNeedsUpdate(_ menu: NSMenu) {
            menu.items = highlighted.value == nil
                ? []
                : [
                    .child("Open", #selector(open)) {
                        $0.target = self
                        $0.image = .init(systemSymbolName: "viewfinder", accessibilityDescription: nil)
                    },
                    .child("Edit", #selector(edit)) {
                        $0.target = self
                        $0.image = .init(systemSymbolName: "slider.horizontal.3", accessibilityDescription: nil)
                    },
                    .child("Column", #selector(column)) {
                        $0.target = self
                        $0.image = .init(systemSymbolName: "plus", accessibilityDescription: nil)
                    },
                    .separator(),
                    .child("Delete", #selector(delete)) {
                        $0.target = self
                        $0.image = .init(systemSymbolName: "trash", accessibilityDescription: nil)
                    }]
        }
        
        @objc private func open() {
            highlighted
                .value
                .map(session
                        .select
                        .send)
        }
        
        @objc private func edit() {
            open()
            
            highlighted
                .value
                .map(Path.board)
                .map(State.edit)
                .map(session
                        .state
                        .send)
        }
        
        @objc private func column() {
            open()
            session.newColumn()
        }
        
        @objc private func delete() {
            open()
            
            highlighted
                .value
                .map(Path.board)
                .map(NSAlert.delete(path:))
        }
    }
}
