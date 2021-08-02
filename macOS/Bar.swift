import AppKit
import Combine

final class Bar: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let cart = Option(icon: "cart.fill")
        cart
            .click
            .sink {
//                NSApp.activity()
            }
            .store(in: &subs)
        
        let preferences = Option(icon: "gearshape.fill")
        preferences.toolTip = "Preferences"
        preferences
            .click
            .sink {
//                NSApp.showPreferencesWindow(nil)
            }
            .store(in: &subs)
        
        let activity = Option(icon: "chart.bar.xaxis")
        activity
            .click
            .sink {
//                NSApp.activity()
            }
            .store(in: &subs)
        
        let plus = Option(icon: "plus.circle.fill")
        plus
            .click
            .sink {
//                NSApp.activity()
            }
            .store(in: &subs)
        
        var left = safeAreaLayoutGuide.leftAnchor
        [cart, preferences, activity, plus]
            .forEach {
                addSubview($0)
                
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                $0.leftAnchor.constraint(equalTo: left, constant: 8).isActive = true
                left = $0.rightAnchor
            }
    }
}
