import AppKit

final class Sidebar: NSVisualEffectView {
    private(set) weak var projects: Item!
    private(set) weak var activity: Item!
    private(set) weak var capacity: Item!
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        material = .sidebar
        
        let projects = Item(title: NSLocalizedString("Projects", comment: ""), icon: "paperplane.fill")
        addSubview(projects)
        self.projects = projects
        
        let activity = Item(title: NSLocalizedString("Activity", comment: ""), icon: "chart.bar.fill")
        addSubview(activity)
        self.activity = activity
        
        let capacity = Item(title: NSLocalizedString("Capacity", comment: ""), icon: "square.stack.fill")
        addSubview(capacity)
        self.capacity = capacity
        
        widthAnchor.constraint(equalToConstant: Metrics.sidebar.width).isActive = true
        
        [projects, activity, capacity].forEach {
            $0.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        projects.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        activity.topAnchor.constraint(equalTo: projects.bottomAnchor, constant: 5).isActive = true
        capacity.topAnchor.constraint(equalTo: activity.bottomAnchor, constant: 5).isActive = true
    }
}
