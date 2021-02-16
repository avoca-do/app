import AppKit

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
    
    func applicationWillFinishLaunching(_: Notification) {
//        mainMenu = Menu()
        Window().makeKeyAndOrderFront(nil)
    }
    
    func applicationDidFinishLaunching(_: Notification) {
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
