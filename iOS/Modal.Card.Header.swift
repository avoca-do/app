import SwiftUI

extension Modal.Card {
    struct Header: View {
        @Binding var session: Session
        let dismiss: () -> Void
        @State private var move = false
        
        var body: some View {
            ZStack {
                GeometryReader { proxy in
                    HStack {
                        if session.path._column > 0 {
                            Button {
                                update(session.path._column - 1)
                            } label: {
                                Text(verbatim: session.archive[title: .column(session.path.board, session.path._column - 1)])
                                    .lineLimit(1)
                                    .font(Font.callout.bold())
                                    .padding(.leading)
                                Image(systemName: "arrow.left")
                                    .font(.title3)
                                    .padding(.trailing)
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: proxy.size.width * 0.43, maxHeight: .greatestFiniteMagnitude, alignment: .leading)
                            .contentShape(Rectangle())
                        }
                        Spacer()
                        if session.path._column < session.archive.count(session.path.board) - 1 {
                            Button {
                                update(session.path._column + 1)
                            } label: {
                                Image(systemName: "arrow.right")
                                    .font(.title3)
                                    .padding(.leading)
                                Text(verbatim: session.archive[title: .column(session.path.board, session.path._column + 1)])
                                    .lineLimit(1)
                                    .font(Font.callout.bold())
                                    .padding(.trailing)
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: proxy.size.width * 0.43, maxHeight: .greatestFiniteMagnitude, alignment: .trailing)
                            .contentShape(Rectangle())
                        }
                    }
                }
                Button {
                    move = true
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundColor(.black)
                        .font(.title3)
                }
                .frame(width: 60)
                .frame(maxHeight: .greatestFiniteMagnitude)
                .contentShape(Rectangle())
                .sheet(isPresented: $move, onDismiss: dismiss) {
                    Board.Move(session: $session)
                }
            }
            .frame(height: 60)
        }
        
        private func update(_ position: Int) {
            
            withAnimation(.spring(blendDuration: 0.35)) {
                session.archive.move(session.path, horizontal: position)
                session.path = .card(.column(session.path.board, position), 0)
            }
        }
    }
}
