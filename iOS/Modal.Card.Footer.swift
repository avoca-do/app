import SwiftUI

extension Modal.Card {
    struct Footer: View {
        @Binding var session: Session
        @Binding var edit: Bool
        let dismiss: () -> Void
        
        var body: some View {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.black)
                }
                .frame(width: 64, height: 60)
                .contentShape(Rectangle())
                Button {
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
