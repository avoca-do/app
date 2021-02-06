import SwiftUI

extension Board.Modify {
    struct Column: View {
        @Binding var session: Session
        let board: Int
        let column: Int
        @State private var delete = false
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            VStack {
                Title(session: $session, title: session[board][column].title)
                
                Tool(text: "Rename", image: "text.cursor") {
                    session.become.send()
                }
                
                Tool(text: "Delete", image: "trash") {
                    delete = true
                }
                .actionSheet(isPresented: $delete) {
                    .init(title: .init("Delete"),
                                 message: .init("Remove this column"),
                                 buttons: [
                                     .destructive(.init("Delete")) {
                                        session[board].drop(column: column)
                                        visible.wrappedValue.dismiss()
                                     },
                                     .cancel()])
                }
                
                Field(session: $session, mode: .column(board, column))
                    .frame(height: 0)
                
                Spacer()
            }
        }
    }
}
