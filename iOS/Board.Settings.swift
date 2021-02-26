import SwiftUI

extension Board {
    struct Settings: View {
        @Binding var session: Session
        @State private var delete = false
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            VStack {
                Title(session: $session, title: session.archive[name: session.path])
                
                Tool(text: "Rename", image: "text.cursor") {
                    session.become.send(.edit(session.path))
                }
                .padding(.top, 40)
                
                Tool(text: "Delete", image: "trash") {
                    UIApplication.shared.resign()
                    delete = true
                }
                .actionSheet(isPresented: $delete) {
                    .init(title: .init("Delete"),
                                 message: .init("Remove this board"),
                                 buttons: [
                                     .destructive(.init("Delete")) {
                                        session.archive.delete(session.path)
                                        visible.wrappedValue.dismiss()
                                        session.path = .archive
                                     },
                                     .cancel()])
                }
                
                Field(session: $session, write: .edit(session.path))
                    .frame(height: 0)
                
                Spacer()
            }
        }
    }
}
