import SwiftUI

extension Middlebar.Item {
    struct Style: ButtonStyle {
        let name: String
        let date: String
        
        func makeBody(configuration: Configuration) -> some View {
            ZStack {
                RoundedRectangle(cornerRadius: Metrics.corners)
                    .fill(configuration.isPressed ? Color.accentColor.opacity(Metrics.accent.high) : .clear)
                VStack(alignment: .leading) {
                    Text(verbatim: name)
                        .font(Font.callout.bold())
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(verbatim: date)
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding()
            }
            .contentShape(Rectangle())
        }
    }
}
