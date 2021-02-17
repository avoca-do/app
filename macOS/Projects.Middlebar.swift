import AppKit
import Combine
import Kanban

extension Projects {
    final class Middlebar: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            wantsLayer = true
            layer!.backgroundColor = .init(gray: 0, alpha: 0.1)
            layer!.borderWidth = 2
            layer!.borderColor = .init(gray: 0, alpha: 0.3)
            
            let titlebar = Titlebar()
            addSubview(titlebar)
            
            let scroll = Scroll()
            scroll.drawsBackground = false
            addSubview(scroll)
            
            widthAnchor.constraint(equalToConstant: Metrics.sidebar.width).isActive = true
            
            titlebar.topAnchor.constraint(equalTo: topAnchor).isActive = true
            titlebar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            titlebar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            titlebar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            
            scroll.topAnchor.constraint(equalTo: titlebar.bottomAnchor).isActive = true
            scroll.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
            scroll.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
            scroll.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
            scroll.right.constraint(equalTo: scroll.rightAnchor).isActive = true
            scroll.bottom.constraint(greaterThanOrEqualTo: scroll.bottomAnchor).isActive = true
            
            Session.shared.archive.removeDuplicates {
                $0.count(.archive) == $1.count(.archive)
            }.sink { archive in
                scroll.views.forEach { $0.removeFromSuperview() }
                var top = scroll.top
                (0 ..< archive.count(.archive)).forEach {
                    let item = Item(path: .board(0), name: archive[name: .board($0)], date: "world")
                    scroll.add(item)
                    
                    item.topAnchor.constraint(equalTo: top).isActive = true
                    item.leftAnchor.constraint(equalTo: scroll.left).isActive = true
                    item.rightAnchor.constraint(equalTo: scroll.right).isActive = true
                    top = item.bottomAnchor
                }
                
                if top != scroll.top {
                    scroll.bottom.constraint(greaterThanOrEqualTo: top, constant: 20).isActive = true
                }
            }.store(in: &subs)
            
            Session.shared.path.removeDuplicates {
                guard $0 != .archive, $1 != .archive else { return false }
                return $0._board == $1._board
            }.sink { path in
                scroll.views.compactMap {
                    $0 as? Item
                }.forEach {
                    $0.state = $0.path == path ? .selected : .on
                }
            }.store(in: &subs)
        }
    }
}
