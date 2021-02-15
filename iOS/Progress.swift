import SwiftUI
import Kanban

struct Progress: View {
    @Binding var session: Session
    let progress: Kanban.Progress
    @State private var percentage = Double()
    @State private var counter = Double()
    private let timer = Timer.publish(every: 0.025, on: .main, in: .common).autoconnect()

    
    var body: some View {
        ZStack {
            Group {
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
            .padding()
            VStack {
                Title(session: $session, title: session.archive[name: session.path])
                Spacer()
                HStack {
                    Text(NSNumber(value: progress.cards), formatter: session.decimal)
                        .font(Font.title.bold())
                        .padding(.leading)
                    Text(progress.cards == 1 ? "Card" : "Cards")
                        .font(.callout)
                    Spacer()
                    Text(verbatim: session.archive[title: .column(session.path.board, session.archive.count(session.path.board) - 1)])
                        .font(.callout)
                        .lineLimit(1)
                    Text(NSNumber(value: progress.done), formatter: session.decimal)
                        .font(Font.title.bold())
                        .padding(.trailing)
                }
                .padding()
                .padding(.bottom)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                percentage = progress.percentage
            }
        }
        .onReceive(timer) { _ in
            if counter < progress.percentage {
                counter += 0.01
            } else {
                timer.upstream.connect().cancel()
                counter = progress.percentage
            }
        }
    }
}
