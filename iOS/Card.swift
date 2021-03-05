import SwiftUI
import Kanban

struct Card: View {
    @Binding var session: Session
    let path: Kanban.Path
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                session.path = path
            }
        } label: {
            HStack {
                VStack(spacing: 0) {
                    Circle()
                        .fill(Color(.tertiaryLabel))
                        .frame(width: Metrics.card.circle, height: Metrics.card.circle)
                    Rectangle()
                        .fill(Color(.tertiaryLabel))
                        .frame(width: Metrics.card.line)
                }
                .padding(.vertical, 2)
                Text(verbatim: session.archive[content: path])
                    .kerning(1)
                    .foregroundColor(.primary)
                    .padding(.leading, 5)
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .contentShape(Rectangle())
        }
    }
}
