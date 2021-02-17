import AppKit

final class Projects: NSView {
    private weak var middlebar: Middlebar!
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        
        let middlebar = Middlebar()
        addSubview(middlebar)
        self.middlebar = middlebar
        
        middlebar.topAnchor.constraint(equalTo: topAnchor).isActive = true
        middlebar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        middlebar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }
}
