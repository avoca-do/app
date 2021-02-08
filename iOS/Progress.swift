import SwiftUI

struct Progress: View {
    @Binding var session: Session
    let board: Int
    
    var body: some View {
        ZStack {
            Group {
                Ring(amount: 1)
                    .stroke(Color.accentColor.opacity(0.2), lineWidth: Metrics.progress.stroke)
                Ring(amount: 0.01)
                    .stroke(LinearGradient(
                                gradient: .init(colors: [.accentColor, .purple]),
                                startPoint: .top,
                                endPoint: .bottom),
                            style: .init(lineWidth: Metrics.progress.stroke,
                                         lineCap: .round))
            }
            .padding()
            VStack {
                Title(session: $session, title: session[board].name)
                Spacer()
            }
        }
    }
}
