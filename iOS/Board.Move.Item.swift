import SwiftUI
import Kanban

extension Board.Move {
    struct Item: View {
        @Binding var session: Session
        @Binding var card: Position
        let board: Int
        let offset: Int
        
        var body: some View {
            HStack {
                ZStack {
                    Circle()
                        .fill(offset == 0 ? Color.accentColor.opacity(0.5) : .clear)
                        .frame(width: 50, height: 50)
                    Text(NSNumber(value: card.index + offset + 1), formatter: session.decimal)
                        .foregroundColor(offset == 0 ? .primary : .secondary)
                        .font(Font.callout.bold())
                }
                .fixedSize()
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(offset == 0 ? Color.accentColor.opacity(0.5) : .clear)
                    Text(verbatim: session[board][card.column, card.index + offset])
                        .lineLimit(2)
                        .foregroundColor(offset == 0 ? .primary : .secondary)
                        .frame(width: 160)
                        .padding()
                }
                .fixedSize()
                .padding(.horizontal)
                Spacer()
                    .frame(width: 50)
            }
        }
    }
}
