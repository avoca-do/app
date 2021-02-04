import SwiftUI
import Kanban

extension Board {
    struct Move: View {
        @Binding var session: Session
        @State var card: Position
        let board: Int
        
        var body: some View {
            VStack {
                Title(session: $session, card: $card, board: board)
                Columns(session: $session, card: $card, board: board)
                Spacer()
                    .frame(height: 30)
                if card.index > 0 {
                    Item(session: $session, card: $card, board: board, offset: -1)
                }
                Item(session: $session, card: $card, board: board, offset: 0)
                if card.index < session[board][card.column].count - 1 {
                    Item(session: $session, card: $card, board: board, offset: 1)
                }
                Spacer()
                
            }
        }
    }
}
