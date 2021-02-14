import SwiftUI
import Kanban

extension Board.Move {
    struct Item: View {
        @Binding var session: Session
        @Binding var card: Position?
        let board: Int
        let offset: Int
        
        var body: some View {
            if card.index + offset >= 0, session[board][card.column].count > card.index + offset {
                ZStack {
                    HStack {
                        Text(NSNumber(value: card.index + offset + 1), formatter: session.decimal)
                            .foregroundColor(offset == 0 ? .primary : .secondary)
                            .font(Font.callout.bold())
                            .padding(.leading)
                        Spacer()
                    }
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.accentColor.opacity(offset == 0 ? 0.3 : 0))
                        .frame(width: 200, height: 60)
                    HStack {
                        Text(verbatim: session[board][card.column, card.index + offset])
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
}
