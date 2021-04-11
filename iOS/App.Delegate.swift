import UIKit
import StoreKit
import Combine
import WidgetKit
import Kanban

extension App {
    final class Delegate: NSObject, UIApplicationDelegate {
        private var widget: AnyCancellable?
        private var fetch: AnyCancellable?
        
        func application(_ application: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            application.registerForRemoteNotifications()
            
            widget = Repository.memory
                .archive
                .merge(with: Repository.memory.save)
                .removeDuplicates()
                .debounce(for: .seconds(1), scheduler: DispatchQueue.global(qos: .utility))
                .sink {
                    Defaults.archive = $0
                    WidgetCenter.shared.reloadAllTimelines()
                }
            
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
        
        func application(_: UIApplication, didReceiveRemoteNotification: [AnyHashable : Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            fetch = Repository.memory
                .receipt
                .sink {
                    fetchCompletionHandler($0 ? .newData : .noData)
                }
        }
    }
}
