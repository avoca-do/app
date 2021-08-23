import SwiftUI

extension Project {
    struct Edit: View {
        @Binding var session: Session
        let board: Int
        @State private var delete = false
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            Popup(title: session.archive[board].name, leading: { }) {
                List {
                    Section {
                        Button {
                            session.modal.send(.write(.edit(.board(board))))
                        } label: {
                            HStack {
                                Text("Rename project")
                                Spacer()
                                Image(systemName: "pencil")
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    
                    Section(header: HStack {
                        Text("Columns")
                            .frame(maxHeight: .greatestFiniteMagnitude, alignment: .bottom)
                        Spacer()
                        Button {
                            session.modal.send(.write(.column(board)))
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                                .frame(height: 50)
                                .padding(.leading, 40)
                                .contentShape(Rectangle())
                        }
                    }) {
                        ForEach(0 ..< session.archive[board].count, id: \.self) { index in
                            Button(session.archive[board][index].name) {
                                session.modal.send(.write(.edit(.column(.board(board), index))))
                            }
                            .foregroundColor(.primary)
                        }
                        .onDelete {
                            $0
                                .first
                                .map {
                                    Notifications.send(message: "Deleted column")
                                    cloud.delete(board: board, column: $0)
                                }
                        }
                    }
                    
                    Section {
                        Button {
                            delete = true
                        } label: {
                            HStack {
                                Text("Delete project")
                                Spacer()
                                Image(systemName: "trash")
                            }
                            .foregroundColor(.pink)
                        }
                    }
                    .actionSheet(isPresented: $delete) {
                        .init(title: .init("Delete project?"),
                              buttons: [
                                .destructive(.init("Delete")) {
                                    visible.wrappedValue.dismiss()
                                    session.board = nil
                                    Notifications.send(message: "Deleted project")
                                    cloud.delete(board: board)
                                },
                                .cancel()])
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
    }
}
