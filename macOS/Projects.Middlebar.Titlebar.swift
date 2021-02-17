import AppKit

extension Projects.Middlebar {
    final class Titlebar: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let plus = Control.Icon(icon: "plus")
            addSubview(plus)
            
            plus.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            plus.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        }
    }
}
