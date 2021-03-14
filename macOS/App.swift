import AppKit
import StoreKit
import Combine
import Kanban

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate {
    static let dark = NSApp.windows.first?.effectiveAppearance == NSAppearance(named: .darkAqua)
    
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        Session.decimal.numberStyle = .decimal
        Session.percentage.numberStyle = .percent
        mainMenu = Menu()
        Window().makeKeyAndOrderFront(nil)
        
        Memory.shared.archive.sink { archive in
            guard archive.date(.archive) > Session.archive.date(.archive) else { return }
            Session.mutate {
                $0 = archive
            }
            Session.path = archive.count(.archive) > Session.path._board
                ? .board(Session.path._board)
                : archive.isEmpty(.archive) ? .archive : .board(0)
            Session.scroll.send()
        }.store(in: &subs)
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        Session.purchases.plusOne.sink {
            Session.mutate {
                $0.capacity += 1
            }
        }.store(in: &subs)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if let created = Defaults.created {
                if !Defaults.rated && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 4 {
                    Defaults.rated = true
                    SKStoreReviewController.requestReview()
                }
            } else {
                Defaults.created = .init()
            }
        }
        
        registerForRemoteNotifications()
        
        Memory.shared.load()
    }
    
    func applicationDidBecomeActive(_: Notification) {
        Memory.shared.fetch()
    }
    
    func application(_: NSApplication, didReceiveRemoteNotification: [String : Any]) {
        Memory.shared.fetch()
    }
    
    @objc func preferences() {
        (windows.first { $0 is Preferences } ?? Preferences()).makeKeyAndOrderFront(nil)
    }
}
