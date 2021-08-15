import AppKit
import Combine

extension Find {
    final class Content: NSView, NSTextFieldDelegate {
        private weak var xmark: Option!
        private weak var field: Field!
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        override init(frame: NSRect) {
            super.init(frame: frame)
            
            let magnifier = Image(icon: "magnifyingglass")
            magnifier.symbolConfiguration = .init(pointSize: 16, weight: .regular)
            magnifier.contentTintColor = .tertiaryLabelColor
            addSubview(magnifier)
            
            let field = Field()
            field.delegate = self
            addSubview(field)
            self.field = field
            
            let separator = Separator(mode: .horizontal)
            addSubview(separator)
            
            let xmark = Option(icon: "xmark.circle.fill")
            xmark.state = .off
            xmark
                .click
                .sink {
                    field.stringValue = ""
                    xmark.state = .off
                }
                .store(in: &subs)
            addSubview(xmark)
            self.xmark = xmark
            
            magnifier.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
            magnifier.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
            
            xmark.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
            xmark.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
            
            field.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            field.leftAnchor.constraint(equalTo: magnifier.rightAnchor).isActive = true
            field.rightAnchor.constraint(equalTo: xmark.leftAnchor).isActive = true
            
            separator.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 5).isActive = true
            separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
        
        func controlTextDidChange(_: Notification) {
            xmark.state = field.stringValue.isEmpty ? .off : .on
        }
        
        func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
            switch doCommandBy {
//            case #selector(cancelOperation), #selector(complete), #selector(NSSavePanel.cancel):
//                if autocomplete.isVisible {
//                    autocomplete.end()
//                } else {
//                    window!.makeFirstResponder(superview!)
//                }
//            case #selector(moveUp):
//                autocomplete.up.send(.init())
//            case #selector(moveDown):
//                autocomplete.down.send(.init())
            default:
                return false
            }
            return true
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
