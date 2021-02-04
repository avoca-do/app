import UIKit
import StoreKit

extension App {
    final class Delegate: NSObject, UIApplicationDelegate {
        func rate() {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                if let created = Defaults.created {
//                    if !Defaults.rated && Calendar.current.dateComponents([.day], from: created, to: .init()).day! > 4 {
//                        Defaults.rated = true
//                        SKStoreReviewController.requestReview(in: UIApplication.shared.windows.first!.windowScene!)
//                    }
//                } else {
//                    Defaults.created = .init()
//                }
//            }
        }
        
        func application(_: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//            UIScrollView.appearance().keyboardDismissMode = .onDrag
            UIScrollView.appearance().scrollsToTop = true
            return true
        }
    }
}
