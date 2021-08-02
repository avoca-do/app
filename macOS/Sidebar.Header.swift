import AppKit

extension Sidebar {
    final class Header: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
//            material = .hudWindow
//            state = .active
            
            let separator = Separator(mode: .horizontal)
            addSubview(separator)
            
            heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        }
    }
}
