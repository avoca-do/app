import UIKit
import StoreKit

extension UIApplication {
    func review() {
        scene
            .map(SKStoreReviewController.requestReview(in:))
    }
    
    private var scene: UIWindowScene? {
        { (connected: [UIWindowScene]) -> UIWindowScene? in
            connected.count > 1
            ? connected
                .filter {
                    $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive
                }
                .first
            : connected
                .first
        } (connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            })
    }
}
