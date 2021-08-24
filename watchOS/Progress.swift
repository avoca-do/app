import SwiftUI
import Kanban

struct Progress: View {
    let archive: Archive
    let board: Int
    let progress: Kanban.Progress
    
    var body: some View {
        ZStack {
            Ring(amount: 1)
                .stroke(Color.primary.opacity(0.2), lineWidth: 8)
            Ring(amount: progress.percentage)
                .stroke(LinearGradient(
                            gradient: .init(colors: [Color.primary.opacity(0.2), .accentColor]),
                            startPoint: .top,
                            endPoint: .bottom),
                        style: .init(lineWidth: 8,
                                     lineCap: .round))
            Text(NSNumber(value: progress.percentage), formatter: NumberFormatter.percent)
                .font(Font.title2.monospacedDigit().weight(.light))
        }
        .padding()
        .navigationTitle((NumberFormatter.decimal.string(from: .init(value: progress.done)) ?? "") + " done")
    }
}
