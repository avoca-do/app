import SwiftUI
import Kanban

extension Project {
    struct Card: View {
        @Binding var session: Session
        let path: Kanban.Path
        
        var body: some View {
            Button {
                session.modal.send(.card(path))
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.init(.quaternarySystemFill))
                    Text(verbatim: session.archive[path.board][path.column][path.card].content)
                        .font(.footnote)
                        .kerning(1)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        .padding(22)
                }
                .padding(.horizontal)
            }
        }
    }
}
