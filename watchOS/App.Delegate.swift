import WatchKit
import Combine
import Kanban

extension App {
    final class Delegate: NSObject, WKExtensionDelegate {
        private var fetch: AnyCancellable?
        
        func applicationDidFinishLaunching() {
            WKExtension.shared().registerForRemoteNotifications()
        }
        
        func applicationDidBecomeActive() {
            Repository.memory.pull.send()
        }
        
        func didReceiveRemoteNotification(_: [AnyHashable : Any], fetchCompletionHandler: @escaping (WKBackgroundFetchResult) -> Void) {
            fetch = Repository
                    .memory
                    .receipt
                    .sink {
                        fetchCompletionHandler($0 ? .newData : .noData)
                    }
        }
    }
}
