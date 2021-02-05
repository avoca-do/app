import SwiftUI
import Kanban

extension Board.Options {
    struct Content: View {
        @Binding var session: Session
        @Binding var card: Position!
        let board: Int
        let dismiss: () -> Void
        @State private var move = false
        
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
                        .padding(.bottom)
                        
                        if session[board][card.column].count > card.index {
                            if card.column < session[board].count - 1 {
                                Item(text: "Move to " + session[board][card.column + 1].title, image: "arrow.right") {
                                    session[board][horizontal: card.column, card.index] = card.column + 1
                                    dismiss()
                                }
                            }
                        }
                        
                        Item(text: "Move", image: "move.3d") {
                            move = true
                        }
                        .sheet(isPresented: $move) {
                            Board.Move(session: $session, card: $card, board: board)
                        }
                        Item(text: "Edit", image: "text.redaction") {
                            
                        }
                        Item(text: "Delete", image: "trash") {
                            
                        }
                        Spacer()
                    }
                }
                .frame(height: Frame.modal.height)
            }
        }
    }
}
