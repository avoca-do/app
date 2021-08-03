import AppKit

final class Sidebar: NSView {
    static let width = CGFloat(260)
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let separator = Separator(mode: .vertical)
        addSubview(separator)
        
        let list = List()
        addSubview(list)
        
        widthAnchor.constraint(equalToConstant: Self.width).isActive = true
        
        separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        list.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: separator.leftAnchor).isActive = true
    }
}
