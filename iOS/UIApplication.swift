import UIKit

extension UIApplication {
    static var dark: Bool {
        shared.windows.map(\.rootViewController?.traitCollection.userInterfaceStyle).first == .dark
    }
}
