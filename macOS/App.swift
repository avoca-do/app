import AppKit
import Combine
import Kanban

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
        
        Memory.shared.archive.sink {
            guard $0.date > Session.shared.archive.value.date else { return }
            Session.shared.archive.value = $0
            Session.shared.dismiss.send()
        }.store(in: &subs)
    }
    
    func applicationWillFinishLaunching(_: Notification) {
//        mainMenu = Menu()
        Window().makeKeyAndOrderFront(nil)
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        Memory.shared.refresh()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
//            if let created = Defaults.created {
//                if !Defaults.rated && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 4 {
//                    Defaults.rated = true
//                    SKStoreReviewController.requestReview()
//                } else if !Defaults.premium && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 6 {
//                    self?.froob()
//                }
//            } else {
//                Defaults.created = .init()
//            }
//        }
    }
}
