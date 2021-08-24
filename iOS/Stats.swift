import SwiftUI
import Kanban

struct Stats: View {
    @Binding var session: Session
    let board: Int
    let progress: Kanban.Progress
    @State private var percentage = Double()
    @State private var counter = Double()
    private let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()

    var body: some View {
        Popup(title: session.archive[board].name, leading: { }) {
            VStack {
                Spacer()
                HStack(spacing: 50) {
                    Group {
                        Text(NSNumber(value: session.archive[board].count), formatter: NumberFormatter.decimal)
                            .foregroundColor(.primary)
                            .font(Font.title3.monospacedDigit().weight(.light))
                        + Text(session.archive[board].count == 1 ? "\nCOLUMN" : "\nCOLUMNS")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.trailing)
                    Group {
                        Text(NSNumber(value: progress.cards), formatter: NumberFormatter.decimal)
                            .foregroundColor(.primary)
                            .font(Font.title3.monospacedDigit().weight(.light))
                        + Text(session.archive[board].count == 1 ? "\nCARD" : "\nCARDS")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.trailing)
                    Group {
                        Text(NSNumber(value: progress.done), formatter: NumberFormatter.decimal)
                            .foregroundColor(.primary)
                            .font(Font.title3.monospacedDigit().weight(.light))
                        + Text("\nDONE")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.trailing)
                }
                ZStack {
                    Ring(amount: 1)
                        .stroke(Color(.quaternarySystemFill), lineWidth: 8)
                    Ring(amount: percentage)
                        .stroke(LinearGradient(
                                    gradient: .init(colors: [.init(.quaternarySystemFill), .accentColor]),
                                    startPoint: .top,
                                    endPoint: .bottom),
                                style: .init(lineWidth: 8,
                                             lineCap: .round))
                    Text(NSNumber(value: counter), formatter: NumberFormatter.percent)
                        .font(Font.largeTitle.monospacedDigit().weight(.light))
                }
                .padding(.horizontal, 50)
                .frame(maxHeight: 400)
                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 2)) {
                    percentage = progress.percentage
                }
            }
        }
        .onReceive(timer) { _ in
            if counter < progress.percentage {
                counter += progress.percentage / 75
            } else {
                timer.upstream.connect().cancel()
                withAnimation(.easeInOut(duration: 0.3)) {
                    counter = progress.percentage
                }
            }
        }
    }
}
