import UIKit
import Combine
import Kanban

extension Editor {
    final class Coordinator: UITextView, UITextViewDelegate {
        private var subs = Set<AnyCancellable>()
        private let wrapper: Editor
        
        required init?(coder: NSCoder) { nil }
        init(wrapper: Editor) {
            self.wrapper = wrapper
            super.init(frame: .zero, textContainer: Container())
            typingAttributes[.font] = UIFont.monospacedSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize + 2, weight: .medium)
            font = .monospacedSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize + 2, weight: .medium)
            textContainerInset = .init(top: 20, left: 20, bottom: 20, right: 20)
            keyboardDismissMode = .none
            backgroundColor = .clear
            tintColor = UIColor(named: "AccentColor")!
            autocapitalizationType = .sentences
            autocorrectionType = Defaults.correction ? .yes : .no
            spellCheckingType = Defaults.spell ? .yes : .no
            alwaysBounceVertical = true
            allowsEditingTextAttributes = false
            keyboardType = .alphabet
            delegate = self
            
            switch wrapper.write {
            case let .edit(path):
                switch path {
                case .card:
                    text = wrapper.session.archive[content: path]
                default: break
                }
            default: break
            }
            
            let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 50), inputViewStyle: .keyboard)
            
            let cancel = UIButton()
            cancel.translatesAutoresizingMaskIntoConstraints = false
            cancel.setImage(UIImage(systemName: "xmark"), for: .normal)
            cancel.addTarget(self, action: #selector(resignFirstResponder), for: .touchUpInside)
            cancel.imageView!.tintColor = .secondaryLabel
            input.addSubview(cancel)
            
            let send = UIButton()
            send.translatesAutoresizingMaskIntoConstraints = false
            send.setImage(UIImage(systemName: "arrow.up.circle.fill")?
                            .withConfiguration(UIImage.SymbolConfiguration(textStyle: .title1)), for: .normal)
            send.addTarget(self, action: #selector(self.send), for: .touchUpInside)
            input.addSubview(send)
            
            cancel.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor).isActive = true
            cancel.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
            cancel.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
            cancel.widthAnchor.constraint(equalToConstant: 60).isActive = true
            
            send.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor).isActive = true
            send.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
            send.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
            send.widthAnchor.constraint(equalToConstant: 60).isActive = true
            
            inputAccessoryView = input
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.becomeFirstResponder()
            }
        }
        
        func textViewDidBeginEditing(_: UITextView) {
            wrapper.session.typing = true
        }
        
        func textViewDidEndEditing(_: UITextView) {
            wrapper.session.typing = false
            wrapper.visible.wrappedValue.dismiss()
        }
        
        override func caretRect(for position: UITextPosition) -> CGRect {
            var rect = super.caretRect(for: position)
            rect.size.width += 2
            return rect
        }
        
        @objc private func send() {
            resignFirstResponder()
            let content = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !content.isEmpty else { return }
            
            switch wrapper.write {
            case let .new(path):
                switch path {
                case .board:
                    wrapper.session.archive.card(path)
                    wrapper.session.archive[content: .card(.column(path, 0), 0)] = content
                default: break
                }
            case let .edit(path):
                switch path {
                case .card:
                    wrapper.session.archive[content: path] = content
                default: break
                }
            }
        }
    }
}
