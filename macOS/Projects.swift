import AppKit
import Combine
import Kanban

final class Projects: NSView {
    private weak var middlebar: Middlebar!
    private var subs = Set<AnyCancellable>()
    
    private var path = Path.archive {
        didSet {
            
        }
    }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let middlebar = Middlebar()
        addSubview(middlebar)
        self.middlebar = middlebar
        
        middlebar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        middlebar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        middlebar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        Session.shared.dismiss.sink { [weak self] in
            self?.refresh()
        }.store(in: &subs)
        
        refresh()
    }
    
    private func refresh() {
        path = Session.shared.archive.value.isEmpty(.archive) ? .archive : .board(0)
    }
    
    private func show(_ view: NSView) {
        subviews.filter {
            !($0 is Middlebar)
        }.forEach {
            $0.removeFromSuperview()
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: middlebar.rightAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}
