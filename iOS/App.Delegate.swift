import UIKit
import StoreKit
import Kanban

extension App {
    final class Delegate: NSObject, UIApplicationDelegate {
        func application(_ application: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            application.registerForRemoteNotifications()
            Memory.shared.load()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if let created = Defaults.created {
                    if !Defaults.rated && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 4 {
                        Defaults.rated = true
                        SKStoreReviewController.requestReview(in: application.windows.first!.windowScene!)
                    }
                } else {
                    Defaults.created = .init()
                }
            }
            
            return true
        }
        
        func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken: Data) {
            print("token")
        }
        
        func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError: Error) {
            print("register")
            print(didFailToRegisterForRemoteNotificationsWithError)
        }
        
        func application(_: UIApplication, didReceiveRemoteNotification: [AnyHashable : Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            print("received")
            Memory.shared.fetch()
            fetchCompletionHandler(.noData)
        }
    }
}
