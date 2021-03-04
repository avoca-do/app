import AppKit
import StoreKit
import Combine
import Kanban

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate {
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
            
            if Defaults.capacity > archive.capacity {
                Session.mutate {
                    $0.capacity = Defaults.capacity
                }
            }
            
            Session.path = archive.isEmpty(.archive) ? .archive : .board(0)
        }.store(in: &subs)
    }
    
    func applicationDidFinishLaunching(_: Notification) {
        Memory.shared.refresh()
        
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
    }
    
    @objc func preferences() {
        (windows.first { $0 is Preferences } ?? Preferences()).makeKeyAndOrderFront(nil)
    }
}
