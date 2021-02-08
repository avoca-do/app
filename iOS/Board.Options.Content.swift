import SwiftUI
import Kanban

extension Board.Options {
    struct Content: View {
        @Binding var session: Session
        @Binding var card: Position!
        let board: Int
        let dismiss: () -> Void
        @State private var move = false
        @State private var edit = false
        @State private var delete = false
        
        var body: some View {
            if card != nil {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.background)
                    VStack {
                        Button(action: dismiss) {
                            HStack {
                                if session[board][card.column].count > card.index {
                                    Text(verbatim: session[board][card.column, card.index])
                                        .lineLimit(1)
                                        .foregroundColor(.primary)
                                        .padding(.horizontal)
                                }
                                Spacer()
                                Image(systemName: "xmark")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                    .frame(width: 60, height: 60)
                            }
                        }
                        .contentShape(Rectangle())
                        
                        if session[board][card.column].count > card.index {
                            if card.column < session[board].count - 1 {
                                Tool(text: "Move to " + session[board][card.column + 1].title, image: "arrow.right") {
                                    session[board][horizontal: card.column, card.index] = card.column + 1
                                    dismiss()
                                }
                            }
                        }
                        
                        Tool(text: "Move", image: "move.3d") {
                            move = true
                        }
                        .sheet(isPresented: $move) {
                            Board.Move(session: $session, card: $card, board: board)
                        }
                        
                        Tool(text: "Edit", image: "text.redaction") {
                            edit = true
                        }
                        .sheet(isPresented: $edit) {
                            Editor(session: $session, board: board, card: card)
                                .padding(.vertical)
                        }
                        
                        Tool(text: "Delete", image: "trash") {
                            delete = true
                        }
                        .actionSheet(isPresented: $delete) {
                            .init(title: .init("Delete"),
                                         message: .init("Remove this card from the board"),
                                         buttons: [
                                             .destructive(.init("Delete")) {
                                                session[board].remove(column: card.column, index: card.index)
                                                dismiss()
                                             },
                                             .cancel()])
                        }
                        
                        Spacer()
                    }
                }
                .frame(height: Metrics.modal.height)
            }
        }
    }
}
