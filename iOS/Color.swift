import SwiftUI

extension Color {
    static let background = Self(.secondarySystemBackground)
    static let main = Self(.main)
    static let border = UIApplication.dark ? Self.black : .init(white: 0, opacity: 0.1)
}

extension UIColor {
    static let main = UIColor.systemBlue
}
