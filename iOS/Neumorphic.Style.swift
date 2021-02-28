import SwiftUI

extension Neumorphic {
    struct Style: ButtonStyle {
        let image: String
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                configuration.label
                if configuration.isPressed {
                    Circle()
                        .fill(UIApplication.dark ? Color.black : .white)
                        .frame(width: 44, height: 44)
                        .padding(4)
                } else {
                    Circle()
                        .fill(Color.background)
                        .shadow(color: Color.black.opacity(UIApplication.dark ? 0.5 : 0.05), radius: 8, x: 8, y: 8)
                        .shadow(color: Color.white.opacity(UIApplication.dark ? 0.04 : 0.6), radius: 3, x: -3, y: -3)
                        .frame(width: 50, height: 50)
                }
                Image(systemName: image)
                    .foregroundColor(configuration.isPressed ? .init(.tertiaryLabel) : .primary)
            }
        }
    }
}



