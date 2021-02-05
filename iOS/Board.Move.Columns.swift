import SwiftUI
import Kanban

extension Board.Move {
    struct Columns: View {
        @Binding var session: Session
        @Binding var card: Position!
        let board: Int
        
        var body: some View {
            HStack {
                HStack {
                    Spacer()
                    if card.column > 0 {
                        Text(verbatim: session[board][card.column - 1].title)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.trailing)
                    }
                }
                VStack {
                    Text(verbatim: session[board][card.column].title)
                        .font(Font.body.bold())
                        .frame(maxWidth: 160)
                        .padding(.horizontal)
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(height: 1)
                }
                .fixedSize()
                HStack {
                    if card.column < session[board].count - 1 {
                        Text(verbatim: session[board][card.column + 1].title)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                    }
                    Spacer()
                }
            }
        }
    }
}
