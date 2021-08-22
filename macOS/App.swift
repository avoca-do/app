import AppKit
import StoreKit
import UserNotifications
import Archivable
import Kanban

let cloud = Cloud.new
let session = Session()
let purchases = Purchases()

@NSApplicationMain final class App: NSApplication, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        delegate = self
    }
    
    func applicationWillFinishLaunching(_: Notification) {
        mainMenu = Menu()
        Window().makeKeyAndOrderFront(nil)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
    
    @objc override func orderFrontStandardAboutPanel(_ sender: Any?) {
        (anyWindow() ?? About())
            .makeKeyAndOrderFront(nil)
    }
    
    func applicationDidFinishLaunching(_: Notification) {
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
        UNUserNotificationCenter.current().delegate = self
    }
    
    func applicationDidBecomeActive(_: Notification) {
        cloud.pull.send()
    }
    
    func application(_: NSApplication, didReceiveRemoteNotification: [String : Any]) {
        cloud.pull.send()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent: UNNotification, withCompletionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        center
            .getDeliveredNotifications {
                center.removeDeliveredNotifications(withIdentifiers: $0
                                                        .map(\.request.identifier)
                                                        .filter {
                                                            $0 != willPresent.request.identifier
                                                        })
            }
        
        guard willPresent.request.trigger is UNPushNotificationTrigger else {
            withCompletionHandler([.banner])
            return
        }
        center.removeDeliveredNotifications(withIdentifiers: [willPresent.request.identifier])
    }
}
