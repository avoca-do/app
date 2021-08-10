import AppKit
import Combine

final class Project: Collection<Project.Cell, Project.Info>, NSMenuDelegate {
    private let double = PassthroughSubject<CGPoint, Never>()

    required init?(coder: NSCoder) { nil }
    init(board: Int) {
        super.init()
        hasHorizontalScroller = true
        horizontalScroller!.controlSize = .mini
        wantsLayer = true
        menu = NSMenu()
        menu!.delegate = self
        
        let vertical = CGFloat(20)
        let horizontal = CGFloat(50)
        let insetsHorizontal = CGFloat(80)
        let insetsVertical = CGFloat(5)
        let width = CGFloat(300)
        let textWidth = width - Cell.horizontal
        let info = CurrentValueSubject<[[Info]], Never>([])
        
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
    }
    
    override func mouseUp(with: NSEvent) {
        switch with.clickCount {
        case 2:
            double.send(point(with: with))
        default:
            super.mouseUp(with: with)
        }
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
                .child("Delete", #selector(delete)) {
                    $0.target = self
                    $0.image = .init(systemSymbolName: "trash", accessibilityDescription: nil)
                }]
    }
    
    @objc private func edit() {
        highlighted
            .value
            .map {
                .edit($0)
            }
            .map(session
                    .state
                    .send)
    }
    
    @objc private func delete() {
        highlighted
            .value
            .map(NSAlert.delete(path:))
    }
}
