import SwiftUI
import Kanban

extension Board.Move {
    struct Item: View {
        @Binding var session: Session
        let offset: Int
        
        var body: some View {
            ZStack {
                HStack {
                    Text(NSNumber(value: session.path._card + offset + 1), formatter: session.decimal)
                        .foregroundColor(offset == 0 ? .primary : .secondary)
                        .font(Font.callout.bold())
                        .padding(.leading)
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor.opacity(offset == 0 ? 0.3 : 0))
                    .frame(width: 200, height: 60)
                HStack {
                    Text(verbatim: session.archive[content: .card(session.path.column, session.path._card + offset)])
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(offset == 0 ? .primary : .secondary)
                        .padding()
                    Spacer()
                }
                .frame(width: 192)
            }
        }
    }
}
