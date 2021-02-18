import AppKit
import Combine
import Kanban

final class Board: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let scroll = Scroll()
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        scroll.hasHorizontalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        scroll.horizontalScroller!.controlSize = .mini
        addSubview(scroll)
        
        scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor, constant: -1).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
        scroll.right.constraint(greaterThanOrEqualTo: scroll.rightAnchor).isActive = true
        scroll.bottom.constraint(greaterThanOrEqualTo: scroll.bottomAnchor).isActive = true
        
        Session.shared.archive.sink { archive in
            scroll.views.forEach { $0.removeFromSuperview() }
            var top = scroll.top
            (0 ..< archive.count(Session.shared.path.value.board)).map {
                Path.column(Session.shared.path.value.board, $0)
            }.forEach { path in
                let column = Column(path: path)
                scroll.add(column)
                
                column.topAnchor.constraint(equalTo: top).isActive = true
                column.leftAnchor.constraint(equalTo: scroll.left).isActive = true
                column.rightAnchor.constraint(equalTo: scroll.right).isActive = true
                
                top = column.bottomAnchor
            }
            
            if top != scroll.top {
                scroll.bottom.constraint(greaterThanOrEqualTo: top).isActive = true
            }
        }.store(in: &subs)
    }
}
