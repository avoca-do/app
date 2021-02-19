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

            let scroll = Scroll()
            scroll.drawsBackground = false
            scroll.hasVerticalScroller = true
            scroll.verticalScroller!.controlSize = .mini
            addSubview(scroll)
            
            widthAnchor.constraint(equalToConstant: Metrics.sidebar.width).isActive = true
            
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            scroll.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
            scroll.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
            scroll.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
            scroll.right.constraint(equalTo: scroll.rightAnchor).isActive = true
            scroll.bottom.constraint(greaterThanOrEqualTo: scroll.bottomAnchor).isActive = true
            
            Session.archiving.removeDuplicates {
                $0.count(.archive) == $1.count(.archive)
            }.sink { archive in
                scroll.views.forEach { $0.removeFromSuperview() }
                var top = scroll.top
                (0 ..< archive.count(.archive)).forEach {
                    let item = Item(path: .board($0))
                    scroll.add(item)
                    
                    item.topAnchor.constraint(equalTo: top).isActive = true
                    item.leftAnchor.constraint(equalTo: scroll.left).isActive = true
                    item.rightAnchor.constraint(equalTo: scroll.right).isActive = true
                    
                    if $0 < archive.count(.archive) {
                        let separator = NSView()
                        separator.translatesAutoresizingMaskIntoConstraints = false
                        separator.wantsLayer = true
                        separator.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.1).cgColor
                        scroll.add(separator)
                        
                        separator.topAnchor.constraint(equalTo: item.bottomAnchor).isActive = true
                        separator.leftAnchor.constraint(equalTo: scroll.left, constant: 16).isActive = true
                        separator.rightAnchor.constraint(equalTo: scroll.right).isActive = true
                        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
                        top = separator.bottomAnchor
                    } else {
                        top = item.bottomAnchor
                    }
                }
                
                if top != scroll.top {
                    scroll.bottom.constraint(greaterThanOrEqualTo: top).isActive = true
                }
            }.store(in: &subs)
            
            Session.pathing.sink { path in
                scroll.views.compactMap {
                    $0 as? Item
                }.forEach { item in
                    item.state = item.path == path ? .selected : .on
                    if item.path == path {
                        DispatchQueue.main.async { [weak item] in
                            item.map {
                                scroll.center($0.frame)
                            }
                        }
                    }
                }
            }.store(in: &subs)
        }
    }
}
