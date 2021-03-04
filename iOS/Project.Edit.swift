import SwiftUI
import Kanban

extension Project {
    struct Edit: View {
        @Binding var session: Session
        let path: Kanban.Path
        @State private var delete = false
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            VStack {
                Dismisser(session: $session)
                Text(verbatim: title)
                    .multilineTextAlignment(.center)
                    .font(Font.title2.bold())
                    .padding()
                
                Tool(text: "Rename", image: "text.cursor") {
                    session.become.send(.edit(path))
                }
                .padding(.top, 40)
                
                Tool(text: "Delete", image: "trash") {
                    UIApplication.shared.resign()
                    delete = true
                }
                .opacity(deletable ? 1 : 0.3)
                .disabled(!deletable)
                .actionSheet(isPresented: $delete) {
                    .init(title: .init("Delete"),
                          message: .init(verbatim: mode),
                          buttons: [
                            .destructive(.init("Delete")) {
                                switch path {
                                case .board:
                                    session.archive.delete(path)
                                    visible.wrappedValue.dismiss()
                                    session.path = .archive
                                    session.open = false
                                case .column:
                                    if session.archive.count(path.board) > 1 {
                                        session.archive.drop(path)
                                        visible.wrappedValue.dismiss()
                                        session.path = .column(path.board, 0)
                                    }
                                default: break
                                }
                            },
                            .cancel()])
                }
                
                Field(session: $session, write: .edit(path))
                    .frame(height: 0)
                
                Spacer()
            }
            .ignoresSafeArea(.keyboard)
        }
        
        private var title: String {
            switch path {
            case .board:
                return session.archive[name: path]
            case .column:
                return session.archive[title: path]
            default:
                return ""
            }
        }
        
        private var mode: String {
            switch path {
            case .board:
                return "Project"
            case .column:
                return "Column"
            default:
                return ""
            }
        }
        
        private var deletable: Bool {
            switch path {
            case .column:
                return session.archive.count(path.board) > 1
            default:
                return true
            }
        }
    }
}
