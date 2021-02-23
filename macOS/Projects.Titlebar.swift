import AppKit
import Combine

extension Projects {
    final class Titlebar: NSView {
        private weak var left: NSLayoutConstraint?
        private weak var project: Control!
        private weak var settings: Control!
        private weak var columns: Control!
        private weak var card: Control!
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
            
            let project = Control.Squircle(icon: "plus")
            project.click.sink { [weak self] in
                self?.triggerProject()
            }.store(in: &subs)
            self.project = project
            
            let settings = Control.Squircle(icon: "slider.vertical.3")
            settings.click.sink { [weak self] in
                self?.triggerSettings()
            }.store(in: &subs)
            self.settings = settings
            
            let columns = Control.Squircle(icon: "line.horizontal.3.decrease")
            columns.click.sink { [weak self] in
                self?.triggerColumns()
            }.store(in: &subs)
            self.columns = columns
            
            let card = Control.Squircle(icon: "plus")
            card.click.sink { [weak self] in
                self?.triggerCard()
            }.store(in: &subs)
            self.card = card
            
            [project, settings, columns, card].forEach {
                addSubview($0)
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
            
            self.left = left.leftAnchor.constraint(equalTo: leftAnchor)
            self.left!.isActive = true
            
            project.leftAnchor.constraint(equalTo: left.leftAnchor, constant: 10).isActive = true
            settings.rightAnchor.constraint(equalTo: columns.leftAnchor, constant: -5).isActive = true
            columns.rightAnchor.constraint(equalTo: card.leftAnchor, constant: -5).isActive = true
            card.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -5).isActive = true
        }
        
        func triggerProject() {
            Plus().show(relativeTo: project.bounds, of: project, preferredEdge: .minY)
        }
        
        func triggerSettings() {
            Settings().show(relativeTo: settings.bounds, of: settings, preferredEdge: .minY)
        }
        
        func triggerColumns() {
            Columns().show(relativeTo: columns.bounds, of: columns, preferredEdge: .minY)
        }
        
        func triggerCard() {
            Session.edit.send(.new(Session.path.board))
        }
    }
}
