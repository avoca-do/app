import SwiftUI

extension Modal.Card {
    struct Header: View {
        @Binding var session: Session
        let dismiss: () -> Void
        @State private var move = false
        
        var body: some View {
            ZStack {
                HStack {
                    if session.path._column > 0 {
                        Button {
                            
                        } label: {
                            Text(verbatim: session.archive[title: .column(session.path.board, session.path._column - 1)])
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
                                .lineLimit(1)
                                .padding(.trailing)
                        }
                        .frame(maxHeight: .greatestFiniteMagnitude)
                        .contentShape(Rectangle())
                    }
                }
                Button {
                    move = true
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
                .frame(width: 60)
                .frame(maxHeight: .greatestFiniteMagnitude)
                .contentShape(Rectangle())
                .sheet(isPresented: $move, onDismiss: dismiss) {
                    Board.Move(session: $session)
                }
            }
            .frame(height: 60)
            .font(.title3)
        }
    }
}
