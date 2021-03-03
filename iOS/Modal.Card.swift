import SwiftUI

extension Modal {
    struct Card: View {
        @Binding var session: Session
        let dismiss: () -> Void
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: Metrics.corners)
                    .fill(Color.accentColor)
                VStack {
                    Header(session: $session, dismiss: dismiss)
                    Text(verbatim: session.archive[content: session.path])
                        .foregroundColor(Color.black)
                        .frame(height: 140, alignment: .top)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        .padding(.horizontal)
                    Footer(session: $session)
                    
//
//                    if session.path._column < session.archive.count(session.path.board) - 1 {
//                        Tool(text: "Move to " + session.archive[title: .column(session.path.board, session.path._column + 1)],
//                             image: "arrow.right") {
//                            session.archive.move(session.path, horizontal: session.path._column + 1)
//                            session.path = .card(.column(session.path.board, session.path._column + 1), 0)
//                        }
//                    }
//
//                    Tool(text: "Move", image: "move.3d") {
//                        move = true
//                    }
//                    .sheet(isPresented: $move, onDismiss: dismiss) {
//                        Board.Move(session: $session)
//                    }
//
//                    Tool(text: "Edit", image: "text.redaction") {
//                        edit = true
//                    }
//                    .sheet(isPresented: $edit, onDismiss: dismiss) {
//                        Editor(session: $session, write: .edit(session.path))
//                            .padding(.vertical)
//                    }
//
//                    Tool(text: "Delete", image: "trash") {
//                        delete = true
//                    }
//                    .actionSheet(isPresented: $delete) {
//                        .init(title: .init("Delete"),
//                                     message: .init("Remove this card from the board"),
//                                     buttons: [
//                                         .destructive(.init("Delete")) {
//                                            session.archive.remove(session.path)
//                                            dismiss()
//                                         },
//                                         .cancel()])
//                    }
//
                    Spacer()
                }
            }
            .frame(height: Metrics.modal.height)
        }
    }
}
