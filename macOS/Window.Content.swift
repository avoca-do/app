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
            
            session
                .state
                .removeDuplicates()
                .sink {
                    let next: NSView
                    
                    switch $0 {
                    case .none:
                        next = Start()
                    case let .view(board):
                        next = Project(board: board)
                    case let .empty(board):
                        next = Empty(board: board)
                    default:
                        next = Edit(state: $0)
                    }
                    
                    self.addSubview(next)
                    
                    next.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                    next.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor).isActive = true
                    next.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
                    let top = next.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: self.safeAreaRect.height)
                    top.isActive = true

                    if let removing = previous {
                        self.layoutSubtreeIfNeeded()
                        top.constant = 0
                        NSAnimationContext
                            .runAnimationGroup {
                                $0.duration = 0.4
                                $0.allowsImplicitAnimation = true
                                $0.timingFunction = .init(name: .easeInEaseOut)
                                removing.alphaValue = 0
                                self.layoutSubtreeIfNeeded()
                            } completionHandler: {
                                removing.removeFromSuperview()
                            }
                    }
                    
                    previous = next
                }
                .store(in: &subs)
        }
    }
}
