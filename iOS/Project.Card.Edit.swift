import SwiftUI
import Kanban

extension Project.Card {
    struct Edit: View {
        @Binding var session: Session
        @State var path: Kanban.Path
        @State private var hit = true
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
                        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatesçtFiniteMagnitude, alignment: .topLeading)
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
                        
                        if path.column > 0 {
                            Option(icon: "arrow.left.circle.fill") {
                                cloud
                                    .move(board: path.board, column: path.column, card: path.card, horizontal: path.column - 1)
                                move(column: path.column - 1, card: 0)
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        if path.card > 0 {
                            Option(icon: "arrow.up.circle.fill") {
                                cloud
                                    .move(board: path.board, column: path.column, card: path.card, vertical: path.card - 1)
                                move(column: path.column, card: path.card - 1)
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        if path.card < session.archive[path.board][path.column].count - 1 {
                            Option(icon: "arrow.down.circle.fill") {
                                cloud
                                    .move(board: path.board, column: path.column, card: path.card, vertical: path.card + 1)
                                move(column: path.column, card: path.card + 1)
                            }
                            .foregroundColor(.secondary)
                        }
                        
                        if path.column < session.archive[path.board].count - 1 {
                            Option(icon: "arrow.right.circle.fill") {
                                cloud
                                    .move(board: path.board, column: path.column, card: path.card, horizontal: path.column + 1)
                                move(column: path.column + 1, card: 0)
                            }
                            .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        Option(icon: "pencil.circle.fill") {
                            session.modal.send(.write(.edit(path)))
                        }
                        .foregroundColor(.accentColor)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 25)
                }
                .allowsHitTesting(hit)
            }
        }
        
        private func move(column: Int, card: Int) {
            hit = false
            withAnimation(.easeInOut(duration: 0.5)) {
                path = .card(.column(.board(path.board), column), card)
            }
            
            DispatchQueue
                .main
                .asyncAfter(deadline: .now() + 0.5) {
                    hit = true
                }
        }
    }
}
