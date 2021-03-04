import SwiftUI

extension Project {
    struct Settings: View {
        @Binding var session: Session
        @State private var delete = false
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            VStack {
                Dismisser(session: $session)
                Text(verbatim: session.archive[name: session.path])
                    .multilineTextAlignment(.center)
                    .font(Font.title2.bold())
                    .padding()
                
                Tool(text: "Rename", image: "text.cursor") {
                    session.become.send(.edit(session.path.board))
                }
                .padding(.top, 40)
                
                Tool(text: "Delete", image: "trash") {
                    UIApplication.shared.resign()
                    delete = true
                }
                .actionSheet(isPresented: $delete) {
                    .init(title: .init("Delete"),
                                 message: .init("Project"),
                                 buttons: [
                                     .destructive(.init("Delete")) {
                                        session.archive.delete(session.path.board)
                                        visible.wrappedValue.dismiss()
                                        session.path = .archive
                                        session.open = false
                                     },
                                     .cancel()])
                }
                
                Field(session: $session, write: .edit(session.path.board))
                    .frame(height: 0)
                
                Spacer()
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}
