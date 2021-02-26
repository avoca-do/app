import SwiftUI
import Kanban

extension Board.Modify {
    struct Column: View {
        @Binding var session: Session
        let path: Kanban.Path
        @State private var delete = false
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            VStack {
                Title(session: $session, title: session.archive[title: path])
                
                Tool(text: "Rename", image: "text.cursor") {
                    session.become.send(.edit(path))
                }
                .padding(.top, 40)
                
                Tool(text: "Delete", image: "trash") {
                    UIApplication.shared.resign()
                    delete = true
                }
                .opacity(session.archive.count(session.path.board) > 1 ? 1 : 0.3)
                .allowsHitTesting(session.archive.count(session.path.board) > 1)
                .actionSheet(isPresented: $delete) {
                    .init(title: .init("Delete"),
                                 message: .init("Remove this column"),
                                 buttons: [
                                     .destructive(.init("Delete")) {
                                        session.archive.drop(path)
                                        visible.wrappedValue.dismiss()
                                     },
                                     .cancel()])
                }
                
                Field(session: $session, write: .edit(path))
                    .frame(height: 0)
                
                Spacer()
            }
        }
    }
}
