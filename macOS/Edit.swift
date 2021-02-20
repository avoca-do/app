import AppKit

final class Edit: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = .init(gray: 0, alpha: 0.2)
        
        let top = NSView()
        let bottom = NSView()
        
        [top, bottom].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.wantsLayer = true
            $0.layer!.backgroundColor = .init(gray: 0, alpha: 0.4)
            addSubview($0)
            
            $0.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            $0.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 2).isActive = true
        }
        
        top.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bottom.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
