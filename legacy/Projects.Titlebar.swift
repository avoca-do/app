import AppKit
import Combine

extension Projects {
    final class Titlebar: NSView {
        private weak var left: NSLayoutConstraint?
        private weak var project: Control!
        private weak var settings: Control!
        private weak var columns: Control!
        private weak var progress: Control!
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
            
            let progress = Control.Squircle(icon: "barometer")
            progress.click.sink { [weak self] in
                self?.triggerProgress()
            }.store(in: &subs)
            self.progress = progress
            
            let card = Control.Squircle(icon: "plus")
            card.click.sink { [weak self] in
                self?.triggerCard()
            }.store(in: &subs)
            self.card = card
            
            [project, settings, columns, progress, card].forEach {
                addSubview($0)
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
            
            self.left = left.leftAnchor.constraint(equalTo: leftAnchor)
            self.left!.isActive = true
            
            Session.archiving.sink {
                if $0.isEmpty(.archive) {
                    [settings, columns, progress, card].forEach {
                        $0.isHidden = true
                    }
                } else {
                    [settings, columns, progress, card].forEach {
                        $0.isHidden = false
                    }
                }
            }.store(in: &subs)
            
            project.leftAnchor.constraint(equalTo: left.leftAnchor, constant: 10).isActive = true
            progress.rightAnchor.constraint(equalTo: settings.leftAnchor, constant: -5).isActive = true
            settings.rightAnchor.constraint(equalTo: columns.leftAnchor, constant: -5).isActive = true
            columns.rightAnchor.constraint(equalTo: card.leftAnchor, constant: -5).isActive = true
            card.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -5).isActive = true
        }
        
        func triggerProject() {
            if Session.archive.available {
                Plus(write: .new(.archive)).show(relativeTo: project.bounds, of: project, preferredEdge: .minY)
            } else {
                let alert = NSAlert()
                alert.alertStyle = .informational
                alert.icon = NSImage(systemSymbolName: "paperplane.fill", accessibilityDescription: nil)
                alert.messageText = NSLocalizedString("You have reached your maximum capacity for projects", comment: "")
                alert.informativeText = NSLocalizedString("Check Capacity for more details", comment: "")
                
                let capacity = alert.addButton(withTitle: NSLocalizedString("Capacity", comment: ""))
                let cancel = alert.addButton(withTitle: NSLocalizedString("Cancel", comment: ""))
                capacity.keyEquivalent = "\r"
                cancel.keyEquivalent = "\u{1b}"
                if alert.runModal().rawValue == capacity.tag {
                    Session.capacity.send()
                }
            }
        }
        
        func triggerSettings() {
            Settings(path: Session.path.board).show(relativeTo: settings.bounds, of: settings, preferredEdge: .minY)
        }
        
        func triggerColumns() {
            Columns().show(relativeTo: columns.bounds, of: columns, preferredEdge: .minY)
        }
        
        func triggerProgress() {
            Progress().show(relativeTo: progress.bounds, of: progress, preferredEdge: .minY)
        }
        
        func triggerCard() {
            Session.edit.send(.new(Session.path.board))
        }
    }
}
