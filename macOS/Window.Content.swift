import AppKit
import Combine

extension Window {
    final class Content: NSVisualEffectView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            state = .active
            material = .menu
            
            var previous: NSView?
            var previousTop: NSLayoutConstraint?
            
            session
                .state
                .removeDuplicates()
                .sink {
                    let next: NSView
                    
                    switch $0 {
                    case .none:
                        next = Empty()
                    case let .view(board):
                        next = Project(board: board)
                    default:
                        next = Edit(state: $0)
                    }
                    
                    self.addSubview(next)
                    
                    next.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                    next.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor).isActive = true
                    next.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
                    let newTop = next.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: previous?.frame.height ?? 0)
                    newTop.isActive = true

                    if let removing = previous, let previousTop = previousTop {
                        self.layoutSubtreeIfNeeded()
                        DispatchQueue.main.async {
                            previousTop.constant = -newTop.constant
                            newTop.constant = 0
                            NSAnimationContext
                                .runAnimationGroup {
                                    $0.duration = 0.4
                                    $0.allowsImplicitAnimation = true
                                    self.layoutSubtreeIfNeeded()
                                } completionHandler: {
                                    removing.removeFromSuperview()
                                }
                        }
                    }
                    
                    previousTop = newTop
                    previous = next
                }
                .store(in: &subs)
        }
    }

}
