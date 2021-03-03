import SwiftUI
import Kanban

extension Board {
    struct Move: View {
        @Binding var session: Session
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Button {
                        visible.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                            .foregroundColor(.primary)
                            .frame(width: 86, height: 54)
                            .contentShape(Rectangle())
                    }
                    
                    
                }

                if session.path._card > 1 {
                    Item(session: $session, offset: -2)
                }
                if session.path._card > 0 {
                    Item(session: $session, offset: -1)
                }
                Item(session: $session, offset: 0)
                if session.path._card < session.archive.count(session.path.column) - 1 {
                    Item(session: $session, offset: 1)
                }
                if session.path._card < session.archive.count(session.path.column) - 2 {
                    Item(session: $session, offset: 2)
                }
                Spacer()
                HStack {
                    Arrow(active: session.path._card > 0, image: "arrow.up") {
                        update(vertical: session.path._card - 1)
                    }
                    Arrow(active: session.path._card < session.archive.count(session.path.column) - 1, image: "arrow.down") {
                        update(vertical: session.path._card + 1)
                    }
                }
            }
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
