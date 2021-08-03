import AppKit
import Combine

final class Content: NSVisualEffectView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        state = .active
        material = .menu
        
        session
            .path
            .map { path -> Int? in
                switch path {
                case .archive:
                    return nil
                default:
                    return path._board
                }
            }
            .removeDuplicates()
            .sink { [weak self] in
                guard let self = self else { return }
                self
                    .subviews
                    .forEach {
                        $0.removeFromSuperview()
                    }
                let view: NSView = $0
                    .map(Project.init(board:))
                    ?? Empty()
                self.addSubview(view)
                
                view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            }
            .store(in: &subs)
    }
}
