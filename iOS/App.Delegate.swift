import UIKit
import UserNotifications
import Combine
import WidgetKit
import Kanban

extension App {
    final class Delegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        private var subs = Set<AnyCancellable>()
        
        func application(_ application: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            application.registerForRemoteNotifications()
            
            cloud
                .archive
                .removeDuplicates()
                .debounce(for: .seconds(3), scheduler: DispatchQueue.global(qos: .utility))
                .sink {
                    Defaults.archive = $0
                    WidgetCenter.shared.reloadAllTimelines()
                }
                .store(in: &subs)

            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 3) {
                    if Defaults.created != nil {
                        Defaults.created = .init()
                    }
                }
            
            UNUserNotificationCenter.current().delegate = self
            
            return true
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent: UNNotification, withCompletionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            center
                .getDeliveredNotifications {
                    center
                        .removeDeliveredNotifications(withIdentifiers: $0
                                                        .map(\.request.identifier)
                                                        .filter {
                                                            $0 != willPresent.request.identifier
                                                        })
                }
            
            withCompletionHandler([.banner])
        }
        
        func application(_: UIApplication, didReceiveRemoteNotification: [AnyHashable : Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            cloud
                .receipt {
                    fetchCompletionHandler($0 ? .newData : .noData)
                }
        }
    }
}
