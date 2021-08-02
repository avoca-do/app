import AppKit
import Combine

extension Projects {
    final class Columns: NSPopover {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            behavior = .transient
            contentSize = .init(width: 240, height: 130 + (Session.archive.count(Session.path.board) * 41))
            contentViewController = .init()
            contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
            
            let title = Text()
            title.stringValue = NSLocalizedString("Columns", comment: "")
            title.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold)
            
            let plus = Control.Tool(title: NSLocalizedString("New column", comment: ""), icon: "plus")
            plus.click.sink {
                Plus(write: .new(Session.path.board)).show(relativeTo: plus.bounds, of: plus, preferredEdge: .minY)
            }.store(in: &subs)
            
            [title, plus].forEach {
                contentViewController!.view.addSubview($0)
                
                $0.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 20).isActive = true
                $0.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor, constant: -20).isActive = true
            }
            
            var top = title.bottomAnchor
            (0 ..< Session.archive.count(Session.path.board)).forEach { column in
                let item = Control.Rectangle(title: Session.archive[title: .column(Session.path.board, column)])
                item.layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(.init(App.dark ? Metrics.accent.low : Metrics.accent.high)).cgColor
                item.click.sink {
                    Settings(path: .column(Session.path.board, column)).show(relativeTo: item.bounds, of: item, preferredEdge: .minY)
                }.store(in: &subs)
                contentViewController!.view.addSubview(item)
                
                item.topAnchor.constraint(equalTo: top, constant: top == title.bottomAnchor ? 15 : 5).isActive = true
                item.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 20).isActive = true
                item.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor, constant: -20).isActive = true
                top = item.bottomAnchor
            }
            
            title.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 20).isActive = true
            plus.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -20).isActive = true
            
            Session.archiving.sink { [weak self] _ in
                self?.close()
            }.store(in: &subs)
        }
    }
}
