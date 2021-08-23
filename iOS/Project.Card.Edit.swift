import SwiftUI
import Kanban

extension Project.Card {
    struct Edit: View {
        @Binding var session: Session
        let path: Kanban.Path
        @State private var delete = false
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            Popup(title: session.archive[path.board][path.column].name, leading: { }) {
                VStack {
                    Text(verbatim: session.archive[path.board][path.column][path.card].content)
                        .font(.body)
                        .kerning(1)
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                    HStack(spacing: 0) {
                        Option(icon: "trash.circle.fill") {
                            delete = true
                        }
                        .foregroundColor(.pink)
                        .actionSheet(isPresented: $delete) {
                            .init(title: .init("Delete card?"),
                                  buttons: [
                                    .destructive(.init("Delete")) {
                                        visible.wrappedValue.dismiss()
                                        Notifications.send(message: "Deleted card")
                                        cloud.delete(board: path.board, column: path.column, card: path.card)
                                    },
                                    .cancel()])
                        }
                        
                        Spacer()
                        
                        Option(icon: "arrow.left.circle.fill") {
                            
                        }
                        .foregroundColor(.secondary)
                        
                        Option(icon: "arrow.up.circle.fill") {
                            
                        }
                        .foregroundColor(.secondary)
                        
                        Option(icon: "arrow.down.circle.fill") {
                            
                        }
                        .foregroundColor(.secondary)
                        
                        Option(icon: "arrow.right.circle.fill") {
                            
                        }
                        .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Option(icon: "pencil.circle.fill") {
                            
                        }
                        .foregroundColor(.accentColor)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 25)
                }
            }
        }
    }
}
