import SwiftUI
import Kanban

struct Progress: View {
    @Binding var session: Session
    let progress: Kanban.Progress
    @State private var percentage = Double()
    @State private var counter = Double()
    private let timer = Timer.publish(every: 0.04, on: .main, in: .common).autoconnect()

    
    var body: some View {
        VStack {
            Dismisser(session: $session)
            ZStack {
                Ring(amount: 1)
                    .stroke(Color.accentColor.opacity(0.2), lineWidth: Metrics.progress.stroke)
                Ring(amount: percentage)
                    .stroke(LinearGradient(
                                gradient: .init(colors: [.accentColor, .purple]),
                                startPoint: .top,
                                endPoint: .bottom),
                            style: .init(lineWidth: Metrics.progress.stroke,
                                         lineCap: .round))
                Text(NSNumber(value: counter), formatter: session.percentage)
                    .font(Font.largeTitle.bold())
            }
            .frame(width: 250, height: 250)
            .padding(.top, 40)
            Text(verbatim: session.archive[name: session.path])
                .multilineTextAlignment(.center)
                .font(Font.title2.bold())
                .padding()
            HStack(alignment: .top) {
                Spacer()
                VStack {
                    Text(NSNumber(value: progress.cards), formatter: session.decimal)
                        .font(Font.title.bold())
                    Text(progress.cards == 1 ? "Card" : "Cards")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                .frame(width: 120)
                VStack {
                    Text(NSNumber(value: progress.done), formatter: session.decimal)
                        .font(Font.title.bold())
                    Text(verbatim: session.archive[title: .column(session.path.board, session.archive.count(session.path.board) - 1)])
                        .multilineTextAlignment(.center)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                .frame(width: 120)
                Spacer()
            }
            .padding(.top)
            Spacer()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                percentage = progress.percentage
            }
        }
        .onReceive(timer) { _ in
            if counter < progress.percentage {
                counter += progress.percentage / 25
            } else {
                timer.upstream.connect().cancel()
                counter = progress.percentage
            }
        }
    }
}
