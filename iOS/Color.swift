import SwiftUI

extension Color {
    static let background = Self(.secondarySystemBackground)
    static let border = UIApplication.dark ? Self.black : .init(white: 0, opacity: 0.1)
}
