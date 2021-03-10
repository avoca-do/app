import UIKit
import StoreKit
import Kanban

extension App {
    final class Delegate: NSObject, UIApplicationDelegate {
        func rate() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if let created = Defaults.created {
                    if !Defaults.rated && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 4 {
                        Defaults.rated = true
                        SKStoreReviewController.requestReview(in: UIApplication.shared.windows.first!.windowScene!)
                    }
                } else {
                    Defaults.created = .init()
                }
            }
        }
        
        func application(_: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            UIApplication.shared.registerForRemoteNotifications()
            Memory.shared.load()
            Memory.shared.pull.send()
            return true
        }
        
        func application(_: UIApplication, didReceiveRemoteNotification: [AnyHashable : Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            Memory.shared.pull.send()
            fetchCompletionHandler(.newData)
        }
    }
}
