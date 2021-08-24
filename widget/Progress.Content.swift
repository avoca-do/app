import SwiftUI

extension Progress {
    struct Content: View {
        let entry: Entry
        
        var body: some View {
            ZStack {
                Ring(amount: 1)
                    .stroke(Color.primary.opacity(0.1), lineWidth: 8)
                Ring(amount: entry.percentage)
                    .stroke(LinearGradient(
                                gradient: .init(colors: [.primary.opacity(0.1), .accentColor]),
                                startPoint: .top,
                                endPoint: .bottom),
                            style: .init(lineWidth: 8,
                                         lineCap: .round))
                Group {
                    Text(verbatim: entry.name + "\n")
                        .foregroundColor(.secondary)
                        .font(.caption2)
                    + Text(NSNumber(value: entry.percentage), formatter: NumberFormatter.percent)
                        .font(Font.title3.monospacedDigit().weight(.light))
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            }
            .padding(8)
        }
    }
}
