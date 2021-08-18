import SwiftUI
import Kanban

extension Project {
    struct Card: View {
        @Binding var session: Session
        let path: Kanban.Path
        
        var body: some View {
            HStack {
                VStack(spacing: 0) {
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: Metrics.card.circle, height: Metrics.card.circle)
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(width: Metrics.card.line)
                }
                .padding(2)
                Text(verbatim: session.archive[content: path])
                    .kerning(1)
                    .font(.caption2)
                    .foregroundColor(.primary)
                    .padding(.leading, 6)
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical)
        }
    }
}
