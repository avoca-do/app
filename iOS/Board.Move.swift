import SwiftUI
import Kanban

extension Board {
    struct Move: View {
        @Binding var session: Session
        
        var body: some View {
            VStack {
                Title(session: $session, title: "Move")
                Columns(session: $session)
                    .padding(.top)
                Spacer()
                    .frame(height: 40)
                if session.path._card > 0 {
                    Item(session: $session, offset: -1)
                }
                Item(session: $session, offset: 0)
                if session.path._card < session.archive.count(session.path.column) - 1 {
                    Item(session: $session, offset: 1)
                }
                Spacer()
                HStack {
                    Arrow(active: session.path._card > 0, image: "arrow.up") {
                        update(vertical: session.path._card - 1)
                    }
                }
                HStack {
                    Arrow(active: session.path._column > 0, image: "arrow.left") {
                        update(horizontal: session.path._column - 1)
                    }
                    Arrow(active: session.path._card < session.archive.count(session.path.column) - 1, image: "arrow.down") {
                        update(vertical: session.path._card + 1)
                    }
                    Arrow(active: session.path._column < session.archive.count(session.path.board) - 1, image: "arrow.right") {
                        update(horizontal: session.path._column + 1)
                    }
                }
                .padding(.bottom, 40)
            }
            .animation(.easeInOut(duration: 0.4))
        }
        
        private func update(vertical position: Int) {
            session.archive.move(session.path, vertical: position)
            session.path = .card(session.path.column, position)
        }
        
        private func update(horizontal position: Int) {
            session.archive.move(session.path, horizontal: position)
            session.path = .card(.column(session.path.board, position), 0)
        }
    }
}
