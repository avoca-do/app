import AppKit

final class Sidebar: NSVisualEffectView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        material = .sidebar
        
        widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
}
