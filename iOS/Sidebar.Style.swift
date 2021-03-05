import SwiftUI

extension Sidebar {
    struct Style: ButtonStyle {
        let image: String
        let selected: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: Metrics.corners)
                    .fill(selected ? Color.accentColor : .clear)
                    .frame(width: 44, height: 44)
                Image(systemName: image)
                    .foregroundColor(selected ? .black : .secondary)
            }
        }
    }
}
