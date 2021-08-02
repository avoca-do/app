import AppKit

final class Sidebar: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let separator = Separator(mode: .vertical)
        addSubview(separator)
        
        let header = Header()
        addSubview(header)
        
        widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        header.topAnchor.constraint(equalTo: topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: separator.leftAnchor).isActive = true
    }
}
