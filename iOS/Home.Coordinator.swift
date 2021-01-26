import UIKit
import Combine

extension Home {
    final class Coordinator: UIView, UIKeyInput, UITextFieldDelegate {
        private weak var field: UITextField!
        private var editable = true
        private var subs = Set<AnyCancellable>()
        private let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 62), inputViewStyle: .keyboard)
        private let view: Field
        override var inputAccessoryView: UIView? { input }
        override var canBecomeFirstResponder: Bool { editable }
        
        var hasText: Bool {
            get {
                field.text?.isEmpty == false
            }
            set { }
        }
        
        required init?(coder: NSCoder) { nil }
        init(view: Field) {
            self.view = view
            super.init(frame: .zero)

            let field = UITextField()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.clearButtonMode = .always
            field.autocorrectionType = .no
            field.backgroundColor = .tertiarySystemFill
            field.tintColor = .main
            field.keyboardType = .alphabet
            field.allowsEditingTextAttributes = false
            field.delegate = self
            field.borderStyle = .roundedRect
            field.placeholder = NSLocalizedString("My Kanban Board", comment: "")
            field.returnKeyType = .done
            input.addSubview(field)
            self.field = field
            
            let dismiss = UIButton()
            dismiss.translatesAutoresizingMaskIntoConstraints = false
            dismiss.setImage(UIImage(systemName: "arrow.down")?.withRenderingMode(.alwaysTemplate), for: .normal)
            dismiss.imageView!.tintColor = .secondaryLabel
            dismiss.imageView!.contentMode = .center
            dismiss.imageView!.clipsToBounds = true
            dismiss.addTarget(self, action: #selector(self.dismiss), for: .touchUpInside)
            input.addSubview(dismiss)
            
            view.session.become.sink { [weak self] in
                self?.becomeFirstResponder()
            }.store(in: &subs)
            
            field.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
            field.rightAnchor.constraint(equalTo: dismiss.leftAnchor).isActive = true
            field.centerYAnchor.constraint(equalTo: input.centerYAnchor).isActive = true
            
            dismiss.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor).isActive = true
            dismiss.widthAnchor.constraint(equalToConstant: 54).isActive = true
            dismiss.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
            dismiss.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
        }
        
        @discardableResult override func becomeFirstResponder() -> Bool {
            DispatchQueue.main.async { [weak self] in
                self?.field.becomeFirstResponder()
            }
            return super.becomeFirstResponder()
        }
        
        func textFieldDidBeginEditing(_: UITextField) {
            view.session.typing = true
        }
        
        func textFieldShouldEndEditing(_: UITextField) -> Bool {
            editable = false
            return true
        }
        
        func textFieldDidEndEditing(_: UITextField) {
            view.session.typing = false
            editable = true
        }
        
        func textFieldShouldReturn(_: UITextField) -> Bool {
            field.resignFirstResponder()
            view.session.archive.add()
            view.session.archive[view.session.archive.count - 1].rename(field.text.flatMap { $0.isEmpty ? nil : $0 } ?? field.placeholder!)
            view.session.board.send(view.session.archive.count - 1)
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
