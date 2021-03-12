import SwiftUI
import WidgetKit

extension Progress {
    struct Content: View {
        let entry: Entry
        @State private var percent = NumberFormatter()
        @Environment(\.widgetFamily) private var family: WidgetFamily
        
        var body: some View {
            if entry == .empty {
                Text("Edit widget to continue")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                ZStack {
                    Ring(amount: 1, width: Metrics.progress.stroke / (family == .systemLarge ? 1 : 2))
                        .stroke(Color.accentColor.opacity(0.2), lineWidth: Metrics.progress.stroke / (family == .systemLarge ? 1 : 2))
                    Ring(amount: entry.percentage, width: Metrics.progress.stroke / (family == .systemLarge ? 1 : 2))
                        .stroke(LinearGradient(
                                    gradient: .init(colors: [.accentColor, .purple]),
                                    startPoint: .top,
                                    endPoint: .bottom),
                                style: .init(lineWidth: Metrics.progress.stroke / (family == .systemLarge ? 1 : 2),
                                             lineCap: .round))
                    VStack {
                        Text(NSNumber(value: entry.percentage), formatter: percent)
                            .font(family == .systemLarge ? Font.largeTitle.bold() : Font.callout.bold())
                        Text(verbatim: entry.board)
                            .multilineTextAlignment(.center)
                            .font(family == .systemLarge ? .body : .caption2)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                }
                .padding(family == .systemLarge ? 12 : 6)
                .onAppear {
                    percent.numberStyle = .percent
                }
            }
        }
    }
}
