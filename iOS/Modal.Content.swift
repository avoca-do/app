import SwiftUI

extension Modal {
    struct Content: View {
        @Binding var session: Session
        let dismiss: () -> Void
        @State private var move = false
        @State private var edit = false
        @State private var delete = false
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: Metrics.corners)
                    .fill(Color.accentColor)
                VStack {
                    ZStack {
                        HStack {
                            if session.path._column > 0 {
                                Button {
                                    
                                } label: {
                                    Text(verbatim: session.archive[title: .column(session.path.board, session.path._column - 1)])
                                        .bold()
                                        .lineLimit(1)
                                        .padding(.leading)
                                    Image(systemName: "arrow.left")
                                        .padding(.trailing)
                                }
                                .frame(maxHeight: .greatestFiniteMagnitude)
                                .contentShape(Rectangle())
                            }
                            Spacer()
                            if session.path._column < session.archive.count(session.path.board) - 1 {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "arrow.right")
                                        .padding(.leading)
                                    Text(verbatim: session.archive[title: .column(session.path.board, session.path._column + 1)])
                                        .bold()
                                        .lineLimit(1)
                                        .padding(.trailing)
                                }
                                .frame(maxHeight: .greatestFiniteMagnitude)
                                .contentShape(Rectangle())
                            }
                        }
                        Button {
                            
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        .frame(width: 60)
                        .frame(maxHeight: .greatestFiniteMagnitude)
                        .contentShape(Rectangle())
                    }
                    .foregroundColor(.black)
                    .frame(height: 50)
                    Text(verbatim: session.archive[content: session.path])
                        .foregroundColor(Color(white: 0, opacity: 0.7))
                        .frame(height: 190, alignment: .top)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        .padding([.horizontal, .top])
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "trash")
                        }
                        .frame(width: 64, height: 64)
                        .contentShape(Rectangle())
                        Button {
                            
                        } label: {
                            Image(systemName: "text.cursor")
                        }
                        .frame(width: 64, height: 64)
                        .contentShape(Rectangle())
                    }
                    .font(.title3)
                    .foregroundColor(.black)
                    
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
                .padding()
            }
            .frame(height: Metrics.modal.height)
        }
    }
}
