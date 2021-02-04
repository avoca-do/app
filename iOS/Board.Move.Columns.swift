import SwiftUI
import Kanban

extension Board.Move {
    struct Columns: View {
        @Binding var session: Session
        @Binding var card: Position
        let board: Int
        
        var body: some View {
            HStack {
                HStack {
                    Spacer()
                    if card.column > 0 {
                        Text(verbatim: session[board][card.column - 1].title)
                            .foregroundColor(.secondary)
                            .padding(.trailing)
                    }
                }
                ZStack {
                    Capsule()
                        .fill(Color.accentColor.opacity(0.5))
                        .frame(width: 160, height: 38)
                    Text(verbatim: session[board][card.column].title)
                        .font(Font.title3.bold())
                        .frame(width: 140)
                }
                .fixedSize()
                HStack {
                    if card.column < session[board].count - 1 {
                        Text(verbatim: session[board][card.column + 1].title)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                    }
                    Spacer()
                }
            }
            .padding(.vertical)
        }
    }
}
