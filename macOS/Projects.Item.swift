import AppKit
import Combine

extension Projects {
    final class Item: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            let edit = Edit()
            edit.alphaValue = 0
            let board = Board()
            
            [board, edit].forEach {
                addSubview($0)
                $0.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
                $0.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            }
            
            let top = edit.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -Metrics.edit.closed)
            let height = edit.heightAnchor.constraint(equalToConstant: Metrics.edit.closed)
            top.isActive = true
            height.isActive = true
            
            board.topAnchor.constraint(equalTo: edit.bottomAnchor).isActive = true
            board.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            Session.edit.sink { [weak self] write in
                edit.text.write = write
                top.constant = write == nil ? -Metrics.edit.closed : 0
                height.constant = write == nil ? Metrics.edit.closed : Metrics.edit.height
                NSAnimationContext.runAnimationGroup {
                    $0.duration = write == nil ? 0.3 : 0.4
                    $0.timingFunction = .init(name: .easeInEaseOut)
                    $0.allowsImplicitAnimation = true
                    edit.alphaValue = write == nil ? 0 : 1
                    self?.layoutSubtreeIfNeeded()
                } completionHandler: {
                    if write != nil {
                        self?.window?.makeFirstResponder(edit.text)
                    }
                }

            }.store(in: &subs)
        }
    }
}
