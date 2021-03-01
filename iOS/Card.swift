import SwiftUI
import Kanban

struct Card: View {
    @Binding var session: Session
    let path: Kanban.Path
    
    var body: some View {
        HStack(spacing: 0) {
            Text(verbatim: session.archive[content: path])
                .foregroundColor(.primary)
                .padding(.horizontal)
            Spacer()
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.vertical)
//        .onChange(of: session.path) { [old = session.path] in
//            if old == path && $0 != path {
//               selected = false
//            } else if old != path && $0 == path {
//                selected = true
//            }
//        }
//        .onAppear {
//            if session.path == path {
//                selected = true
//            }
//        }
    }
}
