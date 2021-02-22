import AppKit
import Combine
import Kanban

final class Projects: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let middlebar = Middlebar()
        addSubview(middlebar)
        
        middlebar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        middlebar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        middlebar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        Session.pathing.sink { [weak self] in
            guard let self = self else { return }
            
            let view: NSView
            if $0 == .archive {
                view = Empty()
            } else {
                view = Item()
            }
            
            self.subviews.filter {
                !($0 is Middlebar)
            }.forEach {
                $0.removeFromSuperview()
            }
            
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            view.leftAnchor.constraint(equalTo: middlebar.rightAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }.store(in: &subs)
    }
}
