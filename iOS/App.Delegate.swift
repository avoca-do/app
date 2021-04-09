import UIKit
import StoreKit
import Combine
import WidgetKit
import Kanban
import Archivable

extension App {
    final class Delegate: NSObject, UIApplicationDelegate {
        let memory = Memory<Descriptor>()
        private var subs = Set<AnyCancellable>()
        
        func application(_ application: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            application.registerForRemoteNotifications()
            
            memory
                .archive
                .merge(with: memory.save)
                .removeDuplicates()
                .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
                .sink {
                    Defaults.archive = $0
                    WidgetCenter.shared.reloadAllTimelines()
                }
                .store(in: &subs)
            
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
        
        func application(_ a: UIApplication, didReceiveRemoteNotification: [AnyHashable : Any], fetchCompletionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            memory
                .receipt
                .sink {
                    fetchCompletionHandler($0 ? .newData : .noData)
                }
                .store(in: &subs)
        }
    }
}
