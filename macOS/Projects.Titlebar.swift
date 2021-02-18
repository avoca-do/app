import AppKit
import Combine

extension Projects {
    final class Titlebar: NSView {
        private weak var left: NSLayoutConstraint?
        private var subs = Set<AnyCancellable>()
        
        override var frame: NSRect {
            didSet {
                left?.constant = Metrics.sidebar.width + convert(.zero, from: nil).x
            }
        }
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let left = NSView()
            left.translatesAutoresizingMaskIntoConstraints = false
            addSubview(left)
            
            let project = Control.Icon(icon: "plus")
            project.click.sink {
                Plus().show(relativeTo: project.bounds, of: project, preferredEdge: .minY)
            }.store(in: &subs)
            addSubview(project)
            
            self.left = left.leftAnchor.constraint(equalTo: leftAnchor)
            self.left!.isActive = true
            
            project.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            project.leftAnchor.constraint(equalTo: left.leftAnchor, constant: 10).isActive = true
        }
    }
}
