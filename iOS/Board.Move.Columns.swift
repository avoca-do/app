import SwiftUI
import Kanban

extension Board.Move {
    struct Columns: View {
        @Binding var session: Session
        
        var body: some View {
            HStack {
                HStack {
                    Spacer()
                    if session.path._column > 0 {
                        Text(verbatim: session.archive[title: .column(session.path.board, session.path._column - 1)])
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.trailing)
                    }
                }
                VStack {
                    Text(verbatim: session.archive[title: session.path])
                        .font(Font.body.bold())
                        .frame(maxWidth: 160)
                        .padding(.horizontal)
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(height: 1)
                }
                .fixedSize()
                HStack {
                    if session.path._column < session.archive.count(session.path.board) - 1 {
                        Text(verbatim: session.archive[title: .column(session.path.board, session.path._column + 1)])
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                    }
                    Spacer()
                }
            }
        }
    }
}
