import UIKit
import Combine
import Kanban

extension Field {
    final class Coordinator: UIView, UIKeyInput, UITextFieldDelegate {
        private weak var field: UITextField!
        private var editable = true
        private var subs = Set<AnyCancellable>()
        private let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 48), inputViewStyle: .keyboard)
        private let wrapper: Field
        override var inputAccessoryView: UIView? { input }
        override var canBecomeFirstResponder: Bool { editable }
        
        var hasText: Bool {
            get {
                field.text?.isEmpty == false
            }
            set { }
        }
        
        required init?(coder: NSCoder) { nil }
        init(wrapper: Field) {
            self.wrapper = wrapper
            super.init(frame: .zero)
            
            let field = UITextField()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.clearButtonMode = .always
            field.autocorrectionType = Defaults.correction ? .yes : .no
            field.autocapitalizationType = .words
            field.spellCheckingType = Defaults.spell ? .yes : .no
            field.backgroundColor = UIApplication.dark ? UIColor.label.withAlphaComponent(0.05) : .init(white: 1, alpha: 0.3)
            field.tintColor = .label
            field.allowsEditingTextAttributes = false
            field.delegate = self
            field.borderStyle = .roundedRect
            field.returnKeyType = .done
            input.addSubview(field)
            self.field = field
            
            switch wrapper.write {
            case let .new(path):
                switch path {
                case .archive:
                    field.placeholder = NSLocalizedString("Kanban Board", comment: "")
                case .board:
                    field.placeholder = NSLocalizedString("NEW COLUMN", comment: "")
                default: break
                }
            case let .edit(path):
                switch path {
                case .board:
                    field.text = wrapper.session.archive[name: path]
                case .column:
                    field.text = wrapper.session.archive[title: path]
                default: break
                }
                field.placeholder = field.text
            }
            
            let cancel = UIButton()
            cancel.translatesAutoresizingMaskIntoConstraints = false
            cancel.setImage(UIImage(systemName: "xmark")?
                                .withConfiguration(UIImage.SymbolConfiguration(textStyle: .callout)), for: .normal)
            cancel.imageEdgeInsets.top = 4
            cancel.imageView!.tintColor = .secondaryLabel
            cancel.addTarget(self, action: #selector(self.dismiss), for: .touchUpInside)
            input.addSubview(cancel)
            
            wrapper.session.become.sink { [weak self] in
                guard $0 == wrapper.write else { return }
                self?.becomeFirstResponder()
            }.store(in: &subs)
            
            field.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
            field.rightAnchor.constraint(equalTo: cancel.leftAnchor).isActive = true
            field.bottomAnchor.constraint(equalTo: input.bottomAnchor, constant: -4).isActive = true
            
            cancel.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor).isActive = true
            cancel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            cancel.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
            cancel.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
        }
        
        @discardableResult override func becomeFirstResponder() -> Bool {
            DispatchQueue.main.async { [weak self] in
                self?.field.becomeFirstResponder()
            }
            return super.becomeFirstResponder()
        }
        
        func textFieldDidBeginEditing(_: UITextField) {
            wrapper.session.typing = true
        }
        
        func textFieldShouldEndEditing(_: UITextField) -> Bool {
            editable = false
            return true
        }
        
        func textFieldDidEndEditing(_: UITextField) {
            wrapper.session.typing = false
            editable = true
        }
        
        func textFieldShouldReturn(_: UITextField) -> Bool {
            field.resignFirstResponder()
            let text = field.text.flatMap { $0.isEmpty ? nil : $0 } ?? field.placeholder!
            
            switch wrapper.write {
            case let .new(path):
                switch path {
                case .archive:
                    wrapper.session.archive.add()
                    wrapper.session.archive[name: .board(0)] = text
                case .board:
                    wrapper.session.archive.column(path)
                    wrapper.session.archive[title: .column(path, wrapper.session.archive.count(path) - 1)] = text
                default: break
                }
            case let .edit(path):
                switch path {
                case .board:
                    wrapper.session.archive[name: path] = text
                case .column:
                    wrapper.session.archive[title: path] = text
                default: break
                }
                field.placeholder = field.text
            }
            
            field.text = nil
            return true
        }
        
        func insertText(_: String) { }
        func deleteBackward() { }
        
        @objc private func dismiss() {
            field.text = nil
            field.resignFirstResponder()
        }
    }
}
