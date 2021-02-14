import SwiftUI
import Kanban

struct Progress: View {
    @Binding var session: Session
    let progress: Kanban.Progress
    
    var body: some View {
        ZStack {
            Group {
                Ring(amount: 1)
                    .stroke(Color.accentColor.opacity(0.2), lineWidth: Metrics.progress.stroke)
                Ring(amount: progress.percentage)
                    .stroke(LinearGradient(
                                gradient: .init(colors: [.accentColor, .purple]),
                                startPoint: .top,
                                endPoint: .bottom),
                            style: .init(lineWidth: Metrics.progress.stroke,
                                         lineCap: .round))
                VStack {
                    Text(NSNumber(value: progress.done), formatter: session.decimal)
                        .font(Font.largeTitle.bold())
                    Text(verbatim: session.archive[title: .column(session.path.board, session.archive.count(session.path.board) - 1)])
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 180)
                }
            }
            .padding()
            VStack {
                Title(session: $session, title: session.archive[name: session.path])
                Spacer()
                HStack {
                    Text(NSNumber(value: progress.cards), formatter: session.decimal)
                        .font(Font.title2.bold())
                        .padding(.leading)
                    Text(progress.cards == 1 ? "Card" : "Cards")
                        .font(.footnote)
                    Spacer()
                    Text(NSNumber(value: progress.percentage), formatter: session.percentage)
                        .font(Font.title2.bold())
                        .padding(.trailing)
                }
                .padding()
                .padding(.bottom)
            }
        }
    }
}
