import AppKit
import Combine

final class Bar: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let activity = Option(icon: "chart.pie")
        activity.toolTip = "Activity"
        activity
            .click
            .sink {
//                NSApp.activity()
            }
            .store(in: &subs)
        
        let search = Option(icon: "magnifyingglass")
        search.toolTip = "Search"
        search
            .click
            .sink {
//                NSApp.activity()
            }
            .store(in: &subs)
        
        let plus = Option(icon: "plus", size: 16)
        plus.toolTip = "New project"
        plus
            .click
            .sink {
//                NSApp.activity()
            }
            .store(in: &subs)
        
        
        
        var left = safeAreaLayoutGuide.leftAnchor
        [activity, search, plus]
            .forEach {
                addSubview($0)
                
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                $0.leftAnchor.constraint(equalTo: left, constant: left == safeAreaLayoutGuide.leftAnchor ? 60 : 10).isActive = true
                left = $0.rightAnchor
            }
    }
}
