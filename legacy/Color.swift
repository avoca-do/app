import SwiftUI

extension Color {
    static func index(_ index: Int) -> Self {
        switch index {
        case 0: return .blue
        case 1: return .pink
        case 2: return .green
        case 3: return .purple
        case 4: return .orange
        case 5: return .yellow
        default: return .gray
        }
    }
}
