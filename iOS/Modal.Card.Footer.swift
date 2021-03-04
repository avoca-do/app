import SwiftUI

extension Modal.Card {
    struct Footer: View {
        @Binding var session: Session
        @Binding var edit: Bool
        let dismiss: () -> Void
        @State private var delete = false
        
        var body: some View {
            HStack {
                Button {
                    UIApplication.shared.dismiss()
                    delete = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.black)
                }
                .frame(width: 64, height: 60)
                .contentShape(Rectangle())
                .actionSheet(isPresented: $delete) {
                    .init(title: .init("Delete"),
                                 message: .init("Card"),
                                 buttons: [
                                     .destructive(.init("Delete")) {
                                        session.archive.remove(session.path)
                                        dismiss()
                                     },
                                     .cancel()])
                }
                Button {
                    UIApplication.shared.dismiss()
                    edit = true
                } label: {
                    Image(systemName: "text.cursor")
                        .foregroundColor(.black)
                }
                .frame(width: 64, height: 60)
                .contentShape(Rectangle())
                .sheet(isPresented: $edit, onDismiss: dismiss) {
                    Editor(session: $session, write: .edit(session.path))
                }
            }
            .font(.title3)
        }
    }
}
