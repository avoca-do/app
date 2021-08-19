import UIKit
import Kanban

extension Writer {
    final class Coordinator: UITextView, UITextViewDelegate {
        private let wrapper: Writer
        
        deinit {
            print("writer gone")
        }
        
        required init?(coder: NSCoder) { nil }
        init(wrapper: Writer) {
            self.wrapper = wrapper
            super.init(frame: .zero, textContainer: Container())
            typingAttributes[.font] = UIFont.monospacedSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize + 2, weight: .regular)
            typingAttributes[.kern] = 1
            font = typingAttributes[.font] as? UIFont
            textContainerInset = .init(top: 50, left: 20, bottom: 30, right: 20)
            keyboardDismissMode = .none
            backgroundColor = .clear
            tintColor = .label
            autocapitalizationType = .sentences
            autocorrectionType = Defaults.correction ? .yes : .no
            spellCheckingType = Defaults.spell ? .yes : .no
            alwaysBounceVertical = true
            allowsEditingTextAttributes = false
            delegate = self
            
//            switch wrapper.write {
//            case let .edit(path):
//                switch path {
//                case .card:
//                    text = wrapper.session.archive[content: path]
//                default: break
//                }
//            default: break
//            }
            
            let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 48), inputViewStyle: .keyboard)
            
            let cancel = UIButton()
            cancel.setImage(UIImage(systemName: "xmark")?
                                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 16)), for: .normal)
            cancel.addTarget(self, action: #selector(resignFirstResponder), for: .touchUpInside)
            cancel.imageView!.tintColor = .secondaryLabel
            
            let send = UIButton()
            send.setImage(UIImage(systemName: "arrow.up.circle.fill")?
                            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 25)), for: .normal)
            send.imageView!.tintColor = .label
            send.addTarget(self, action: #selector(self.send), for: .touchUpInside)
            
            let number = UIButton()
            number.setImage(UIImage(systemName: "number")?
                                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)), for: .normal)
            number.addTarget(self, action: #selector(self.number), for: .touchUpInside)
            
            let minus = UIButton()
            minus.setImage(UIImage(systemName: "minus")?
                            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)), for: .normal)
            minus.addTarget(self, action: #selector(self.minus), for: .touchUpInside)
            
            let asterisk = UIButton()
            asterisk.setImage(UIImage(systemName: "staroflife.fill")?
                                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .light)), for: .normal)
            asterisk.addTarget(self, action: #selector(self.asterisk), for: .touchUpInside)
            
            let title = UILabel()
            title.translatesAutoresizingMaskIntoConstraints = false
            title.numberOfLines = 1
            title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(title)
            
            [cancel, send, number, minus, asterisk].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.imageEdgeInsets.top = 4
                input.addSubview($0)
                
                $0.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
                $0.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
                $0.widthAnchor.constraint(equalToConstant: 64).isActive = true
            }
            
            [number, minus, asterisk]
                .forEach {
                    $0.imageView!.tintColor = .label
                }
            
            cancel.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor).isActive = true
            send.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor).isActive = true
            minus.centerXAnchor.constraint(equalTo: input.centerXAnchor).isActive = true
            number.rightAnchor.constraint(equalTo: minus.leftAnchor).isActive = true
            asterisk.leftAnchor.constraint(equalTo: minus.rightAnchor).isActive = true
            
            title.topAnchor.constraint(equalTo: bottomAnchor, constant: 20).isActive = true
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
            title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -25).isActive = true
            
            inputAccessoryView = input
            
            switch wrapper.write {
            case .create:
                title.attributedText = .make("New project",
                                             font: .preferredFont(forTextStyle: .callout),
                                             color: .secondaryLabel)
            case let .column(board):
                title.attributedText = .make {
                    $0.append(.make(wrapper.session.archive[board].name + " : ",
                                    font: .font(style: .callout, weight: .light),
                                    color: .tertiaryLabel,
                                    lineBreak: .byTruncatingMiddle))
                    $0.append(.make("New column",
                                    font: .font(style: .callout, weight: .light),
                                    color: .secondaryLabel))
                }
            case let .card(board):
                title.attributedText = .make {
                    $0.append(.make(wrapper.session.archive[board].name + " : ",
                                    font: .font(style: .callout, weight: .light),
                                    color: .tertiaryLabel,
                                    lineBreak: .byTruncatingMiddle))
                    $0.append(.make("New card",
                                    font: .font(style: .callout, weight: .light),
                                    color: .secondaryLabel))
                }
            case let .edit(path):
                switch path {
                case .card:
                    title.attributedText = .make {
                        $0.append(.make(wrapper.session.archive[path.board].name + " : " + wrapper.session.archive[path.board][path.column].name + " : ",
                                        font: .font(style: .callout, weight: .light),
                                        color: .tertiaryLabel,
                                        lineBreak: .byTruncatingMiddle))
                        $0.append(.make("Edit card",
                                        font: .font(style: .callout, weight: .light),
                                        color: .secondaryLabel))
                    }
                case .column:
                    title.attributedText = .make {
                        $0.append(.make(wrapper.session.archive[path.board].name + " : ",
                                        font: .font(style: .callout, weight: .light),
                                        color: .tertiaryLabel,
                                        lineBreak: .byTruncatingMiddle))
                        $0.append(.make("Edit column",
                                        font: .font(style: .callout, weight: .light),
                                        color: .secondaryLabel))
                    }
                case .board:
                    title.attributedText = .make("Edit board",
                                                 font: .font(style: .callout, weight: .light),
                                                 color: .secondaryLabel)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.becomeFirstResponder()
            }
        }
        
        func textViewDidEndEditing(_: UITextView) {
            wrapper.visible.wrappedValue.dismiss()
        }
        
        override func caretRect(for position: UITextPosition) -> CGRect {
            var rect = super.caretRect(for: position)
            rect.size.width = 2
            return rect
        }
        
        @objc private func send() {
            resignFirstResponder()
            wrapper.session.finish(text: text.trimmingCharacters(in: .whitespacesAndNewlines), write: wrapper.write)
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
