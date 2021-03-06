import SwiftUI

extension Modal.Card {
    struct Horizontal: View {
        @Binding var session: Session
        
        var body: some View {
            GeometryReader { proxy in
                HStack {
                    if session.path._column > 0 {
                        Button {
                            move(session.path._column - 1)
                        } label: {
                            Text(verbatim: session.archive[title: .column(session.path.board, session.path._column - 1)])
                                .lineLimit(1)
                                .font(Font.callout.bold())
                                .padding(.leading)
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .padding(.trailing)
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth: proxy.size.width * 0.43, maxHeight: .greatestFiniteMagnitude, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    Spacer()
                    if session.path._column < session.archive.count(session.path.board) - 1 {
                        Button {
                            move(session.path._column + 1)
                        } label: {
                            Image(systemName: "arrow.right")
                                .font(.title3)
                                .padding(.leading)
                            Text(verbatim: session.archive[title: .column(session.path.board, session.path._column + 1)])
                                .lineLimit(1)
                                .font(Font.callout.bold())
                                .padding(.trailing)
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth: proxy.size.width * 0.43, maxHeight: .greatestFiniteMagnitude, alignment: .trailing)
                        .contentShape(Rectangle())
                    }
                }
            }
        }
        
        private func move(_ position: Int) {
            withAnimation(.spring(blendDuration: 0.35)) {
                session.archive.move(session.path, horizontal: position)
                session.path = .card(.column(session.path.board, position), 0)
            }
        }
    }
}
