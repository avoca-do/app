import UIKit
import Combine

extension Editor {
    final class Coordinator: UITextView, UITextViewDelegate {
        private var subs = Set<AnyCancellable>()
        private let view: Editor
        
        required init?(coder: NSCoder) { nil }
        init(view: Editor) {
            self.view = view
            super.init(frame: .zero, textContainer: Container())
            typingAttributes[.font] = UIFont.monospacedSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize + 2, weight: .medium)
            font = .monospacedSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize + 2, weight: .medium)
            textContainerInset = .init(top: 40, left: 20, bottom: 20, right: 20)
            keyboardDismissMode = .onDrag
            backgroundColor = .clear
            tintColor = UIColor(named: "AccentColor")!
            autocapitalizationType = .sentences
            autocorrectionType = .no
            spellCheckingType = .yes
            alwaysBounceVertical = true
            allowsEditingTextAttributes = false
            keyboardType = .alphabet
            delegate = self
            inputAccessoryView = UIInputView(frame: .init(x: 0, y: 0, width: 0, height: 62), inputViewStyle: .keyboard)
            
            view.session.become.sink { [weak self] in
                self?.becomeFirstResponder()
            }.store(in: &subs)
        }
        
        func textViewDidBeginEditing(_: UITextView) {
            view.session.typing = true
        }
        
        func textViewDidEndEditing(_: UITextView) {
            view.session.typing = false
        }
        
        override func caretRect(for position: UITextPosition) -> CGRect {
            var rect = super.caretRect(for: position)
            rect.size.width += 2
            return rect
        }
    }
}
