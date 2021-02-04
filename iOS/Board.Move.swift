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
                HStack {
                    Arrow(active: card.index > 0, image: "arrow.up") {
                        update(vertical: .init(column: card.column, index: card.index - 1))
                    }
                }
                HStack {
                    Arrow(active: card.column > 0, image: "arrow.left") {
                        update(horizontal: .init(column: card.column - 1, index: card.index))
                    }
                    Arrow(active: card.index < session[board][card.column].count - 1, image: "arrow.down") {
                        update(vertical: .init(column: card.column, index: card.index + 1))
                    }
                    Arrow(active: card.column < session[board].count - 1, image: "arrow.right") {
                        update(horizontal: .init(column: card.column + 1, index: card.index))
                    }
                }
                .padding(.bottom)
            }
        }
        
        private func update(vertical position: Position) {
            session[board][vertical: card.column, card.index] = position.index
            card = position
        }
        
        private func update(horizontal position: Position) {
            session[board][horizontal: card.column, card.index] = position.column
            card = position
        }
    }
}
