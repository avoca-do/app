import AppKit
import Kanban

extension Board {
    final class Column: Control {
        let path: Path
        
        required init?(coder: NSCoder) { nil }
        init(path: Path) {
            self.path = path
            super.init()
            
            let title = Text()
            title.stringValue = Session.shared.archive.value[title: path]
            title.font = .preferredFont(forTextStyle: .title2)
            title.maximumNumberOfLines = 1
            addSubview(title)
            
            bottomAnchor.constraint(equalTo: title.bottomAnchor, constant: Metrics.board.card.vertical).isActive = true
            
            title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            title.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.board.card.vertical).isActive = true
        }
    }
}
