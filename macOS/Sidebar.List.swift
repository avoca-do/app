import AppKit
import Combine
import Kanban

extension Sidebar {
    final class List: Collection<Cell, Info>, NSMenuDelegate {
        static let width = Sidebar.width - insets2
        private static let insets = CGFloat(20)
        private static let insets2 = insets + insets
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            menu = NSMenu()
            menu!.delegate = self
            
            let vertical = CGFloat(20)
            let textWidth = Self.width - Cell.insetsHorizontal2
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
                .combineLatest(pressed
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
                    self?.pressed.send($0)
                }
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .combineLatest(selected
                                .compactMap {
                                    $0
                                })
                .map { _, selected in
                    .view(selected)
                }
                .subscribe(session.state)
                .store(in: &subs)
            
            info
                .removeDuplicates()
                .sink { [weak self] in
                    let result = $0
                        .reduce(into: (items: Set<CollectionItem<Info>>(), y: vertical)) {
                            let height = ceil($1.string.height(for: textWidth) + Cell.insetsVertical2)
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
            
            session
                .select
                .subscribe(pressed)
                .store(in: &subs)
            
            session
                .select
                .compactMap {
                    $0
                }
                .subscribe(selected)
                .store(in: &subs)
        }
        
        func menuNeedsUpdate(_ menu: NSMenu) {
            menu.items = highlighted.value == nil
                ? []
                : [
                    .child("Edit", #selector(edit)) {
                        $0.target = self
                        $0.image = .init(systemSymbolName: "slider.horizontal.3", accessibilityDescription: nil)
                    },
                    .separator(),
                    .child("New Column", #selector(column)) {
                        $0.target = self
                        $0.image = .init(systemSymbolName: "plus", accessibilityDescription: nil)
                    },
                    .separator(),
                    .child("Delete", #selector(delete)) {
                        $0.target = self
                        $0.image = .init(systemSymbolName: "trash", accessibilityDescription: nil)
                    }]
        }
        
        @objc private func edit() {
            highlighted
                .value
                .map(pressed
                        .send)
            
            highlighted
                .value
                .map {
                    .edit(.board($0))
                }
                .map(session
                        .state
                        .send)
        }
        
        @objc private func column() {
            highlighted
                .value
                .map(pressed
                        .send)
            
            highlighted
                .value
                .map {
                    .column($0)
                }
                .map(session
                        .state
                        .send)
        }
        
        @objc private func delete() {
            highlighted
                .value
                .map(pressed
                        .send)
            
            highlighted
                .value
                .map {
                    .board($0)
                }
                .map(NSAlert.delete(path:))
        }
    }
}
