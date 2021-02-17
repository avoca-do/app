import AppKit

final class Sidebar: NSVisualEffectView {
    private(set) weak var projects: Item!
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        material = .sidebar
        
        let projects = Item(title: NSLocalizedString("Projects", comment: ""), icon: "square.stack.3d.up")
        addSubview(projects)
        self.projects = projects
        
        widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        projects.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        projects.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
