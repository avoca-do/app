import SwiftUI

extension Board {
    struct Settings: View {
        @Binding var session: Session
        let board: Int
        @State private var delete = false
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            VStack {
                Title(session: $session, title: "Settings")
                
                Tool(text: "Rename", image: "text.cursor") {
                    session.become.send(.board(board))
                }
                
                Tool(text: "Delete", image: "trash") {
                    UIApplication.shared.resign()
                    delete = true
                }
                .actionSheet(isPresented: $delete) {
                    .init(title: .init("Delete"),
                                 message: .init("Remove this board"),
                                 buttons: [
                                     .destructive(.init("Delete")) {
                                        session.archive.delete(board: board)
                                        visible.wrappedValue.dismiss()
                                        session.board.send(nil)
                                     },
                                     .cancel()])
                }
                
                Field(session: $session, mode: .board(board))
                    .frame(height: 0)
                
                Spacer()
            }
        }
    }
}
