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
            typingAttributes[.kern] = 1
            font = typingAttributes[.font] as? UIFont
            textContainerInset = .init(top: 30, left: 20, bottom: 30, right: 20)
            keyboardDismissMode = .none
            backgroundColor = .clear
            tintColor = UIColor(named: "AccentColor")!
            autocapitalizationType = .sentences
            autocorrectionType = Defaults.correction ? .yes : .no
            spellCheckingType = Defaults.spell ? .yes : .no
            alwaysBounceVertical = true
            allowsEditingTextAttributes = false
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
            
            let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 48), inputViewStyle: .keyboard)
            
            let cancel = UIButton()
            cancel.setImage(UIImage(systemName: "xmark")?
                                .withConfiguration(UIImage.SymbolConfiguration(textStyle: .callout)), for: .normal)
            cancel.imageEdgeInsets.left = -10
            cancel.addTarget(self, action: #selector(resignFirstResponder), for: .touchUpInside)
            cancel.imageView!.tintColor = .secondaryLabel
            
            let send = UIButton()
            send.setImage(UIImage(systemName: "arrow.up.square.fill")?
                            .withConfiguration(UIImage.SymbolConfiguration(textStyle: .title1)), for: .normal)
            send.imageEdgeInsets.right = -10
            send.imageView!.tintColor = UIApplication.dark ? UIColor(named: "AccentColor") : .black
            send.addTarget(self, action: #selector(self.send), for: .touchUpInside)
            
            let number = UIButton()
            number.setImage(UIImage(systemName: "number.square.fill")?
                            .withConfiguration(UIImage.SymbolConfiguration(textStyle: .title1)), for: .normal)
            number.addTarget(self, action: #selector(self.number), for: .touchUpInside)
            
            let minus = UIButton()
            minus.setImage(UIImage(systemName: "minus.square.fill")?
                            .withConfiguration(UIImage.SymbolConfiguration(textStyle: .title1)), for: .normal)
            minus.addTarget(self, action: #selector(self.minus), for: .touchUpInside)
            
            let asterisk = UIButton()
            asterisk.setImage(UIImage(systemName: "asterisk.circle.fill")?
                            .withConfiguration(UIImage.SymbolConfiguration(textStyle: .title1)), for: .normal)
            asterisk.addTarget(self, action: #selector(self.asterisk), for: .touchUpInside)
            
            [cancel, send, number, minus, asterisk].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.imageEdgeInsets.top = 4
                input.addSubview($0)
                
                $0.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
                $0.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
                $0.widthAnchor.constraint(equalToConstant: 60).isActive = true
            }
            
            [number, minus, asterisk].forEach {
                $0.imageView!.tintColor = UIApplication.dark ? .secondaryLabel : .tertiaryLabel
            }
            
            cancel.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor).isActive = true
            send.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor).isActive = true
            asterisk.centerXAnchor.constraint(equalTo: input.centerXAnchor).isActive = true
            minus.rightAnchor.constraint(equalTo: asterisk.leftAnchor).isActive = true
            number.leftAnchor.constraint(equalTo: asterisk.rightAnchor).isActive = true
            
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
            rect.size.width += 1
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
                    wrapper.session.path = .column(path, 0)
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
        
        @objc private func asterisk() {
            insertText("*")
        }
        
        @objc private func minus() {
            insertText("-")
        }
        
        @objc private func number() {
            insertText("#")
        }
    }
}
