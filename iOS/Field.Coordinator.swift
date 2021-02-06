import UIKit
import Combine

extension Field {
    final class Coordinator: UIView, UIKeyInput, UITextFieldDelegate {
        private weak var field: UITextField!
        private var editable = true
        private var subs = Set<AnyCancellable>()
        private let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 62), inputViewStyle: .keyboard)
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
            field.autocorrectionType = .no
            field.autocapitalizationType = .words
            field.spellCheckingType = .yes
            field.backgroundColor = .tertiarySystemFill
            field.tintColor = .main
            field.keyboardType = .alphabet
            field.allowsEditingTextAttributes = false
            field.delegate = self
            field.borderStyle = .roundedRect
            field.returnKeyType = .done
            input.addSubview(field)
            self.field = field
            
            switch wrapper.mode {
            case .newBoard:
                field.placeholder = NSLocalizedString("Kanban Board", comment: "")
            case .newColumn:
                field.placeholder = NSLocalizedString("NEW COLUMN", comment: "")
            case let .board(board):
                field.text = wrapper.session[board].name
                field.placeholder = wrapper.session[board].name
            case let .column(board, column):
                field.text = wrapper.session[board][column].title
                field.placeholder = wrapper.session[board][column].title
            }
            
            let cancel = UIButton()
            cancel.translatesAutoresizingMaskIntoConstraints = false
            cancel.setImage(UIImage(systemName: "xmark"), for: .normal)
            cancel.imageView!.tintColor = .secondaryLabel
            cancel.addTarget(self, action: #selector(self.dismiss), for: .touchUpInside)
            input.addSubview(cancel)
            
            wrapper.session.become.sink { [weak self] in
                self?.becomeFirstResponder()
            }.store(in: &subs)
            
            field.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
            field.rightAnchor.constraint(equalTo: cancel.leftAnchor).isActive = true
            field.centerYAnchor.constraint(equalTo: input.centerYAnchor).isActive = true
            
            cancel.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor).isActive = true
            cancel.widthAnchor.constraint(equalToConstant: 54).isActive = true
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
            switch wrapper.mode {
            case .newBoard:
                wrapper.session.archive.add()
                wrapper.session.archive[0].name = text
            case let .newColumn(board):
                wrapper.session[board].column()
                wrapper.session[board].title(column: wrapper.session[board].count - 1, text)
            case let .board(board):
                wrapper.session.archive[board].name = text
            case let .column(board, column):
                wrapper.session[board].title(column: column, text)
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
