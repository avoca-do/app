import UIKit

extension Find.Bar {
    final class Coordinator: UIView, UIKeyInput, UITextFieldDelegate {
        private weak var field: UITextField!
        private var editable = true
        private let wrapper: Find.Bar
        private let input = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 48), inputViewStyle: .keyboard)
        
        required init?(coder: NSCoder) { nil }
        init(wrapper: Find.Bar) {
            self.wrapper = wrapper
            super.init(frame: .zero)
            
            let field = UITextField()
            field.translatesAutoresizingMaskIntoConstraints = false
            field.clearButtonMode = .always
            field.autocorrectionType = .no
            field.autocapitalizationType = .none
            field.spellCheckingType = .no
            field.backgroundColor = UIApplication.dark ? .init(white: 1, alpha: 0.2) : .init(white: 1, alpha: 0.6)
            field.tintColor = .label
            field.allowsEditingTextAttributes = false
            field.delegate = self
            field.borderStyle = .roundedRect
            field.returnKeyType = .done
//            field.enablesReturnKeyAutomatically = false
            field.leftViewMode = .always
            input.addSubview(field)
            self.field = field
            
            let cancel = UIButton()
            cancel.translatesAutoresizingMaskIntoConstraints = false
            cancel.setImage(UIImage(systemName: "xmark")?
                                .withConfiguration(UIImage.SymbolConfiguration(textStyle: .callout)), for: .normal)
            cancel.imageEdgeInsets.top = 4
            cancel.imageView!.tintColor = .secondaryLabel
            cancel.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
            input.addSubview(cancel)
            
            field.bottomAnchor.constraint(equalTo: input.bottomAnchor, constant: -4).isActive = true
            field.leftAnchor.constraint(equalTo: input.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
            field.rightAnchor.constraint(equalTo: cancel.leftAnchor).isActive = true
            
            cancel.rightAnchor.constraint(equalTo: input.safeAreaLayoutGuide.rightAnchor).isActive = true
            cancel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            cancel.topAnchor.constraint(equalTo: input.topAnchor).isActive = true
            cancel.bottomAnchor.constraint(equalTo: input.bottomAnchor).isActive = true
            
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 0.2) { [weak self] in
                    self?.becomeFirstResponder()
                }
        }
        
        var hasText: Bool {
            get {
                field.text?.isEmpty == false
            }
            set {
                
            }
        }
        
        override var inputAccessoryView: UIView? {
            input
        }
        
        override var canBecomeFirstResponder: Bool {
            editable
        }
        
        func textFieldDidEndEditing(_: UITextField) {
            wrapper.visible.wrappedValue.dismiss()
        }
        
        func textFieldShouldReturn(_: UITextField) -> Bool {
            field.resignFirstResponder()
            return true
        }
        
        func textFieldDidChangeSelection(_: UITextField) {
            wrapper.search = field.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        func textFieldShouldEndEditing(_: UITextField) -> Bool {
            editable = false
            return true
        }
        
        func insertText(_: String) {
            
        }
        
        func deleteBackward() {
            
        }
        
        @discardableResult final override func becomeFirstResponder() -> Bool {
            DispatchQueue
                .main
                .async { [weak self] in
                    self?.field.becomeFirstResponder()
                }
            return super.becomeFirstResponder()
        }
        
        @objc private func dismiss() {
            field.resignFirstResponder()
        }
    }
}
