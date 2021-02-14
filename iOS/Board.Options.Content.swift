import SwiftUI
import Kanban

extension Board.Options {
    struct Content: View {
        @Binding var session: Session
        let dismiss: () -> Void
        @State private var move = false
        @State private var edit = false
        @State private var delete = false
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.background)
                VStack {
                    Button(action: dismiss) {
                        HStack {
                            Text(verbatim: session.archive[content: session.path])
                                .lineLimit(1)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                                .padding(.leading)
                            Spacer()
                            Image(systemName: "xmark")
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .frame(width: 60, height: 45)
                        }
                    }
                    .contentShape(Rectangle())
                    .padding(.top, 10)
                    
                    if session.path._column < session.archive.count(session.path.board) - 1 {
                        Tool(text: "Move to " + session.archive[title: .column(session.path.board, session.path._column + 1)],
                             image: "arrow.right") {
                            session[board][horizontal: card.column, card.index] = card.column + 1
                            dismiss()
                        }
                    }
                    
                    Tool(text: "Move", image: "move.3d") {
                        move = true
                    }
                    .sheet(isPresented: $move, onDismiss: dismiss) {
                        Board.Move(session: $session, card: $card, board: board)
                    }
                    
                    Tool(text: "Edit", image: "text.redaction") {
                        edit = true
                    }
                    .sheet(isPresented: $edit, onDismiss: dismiss) {
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
