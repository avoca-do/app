import SwiftUI
import Kanban

struct Card: View {
    @Binding var session: Session
    let path: Kanban.Path
    
    var body: some View {
        HStack {
            Text(verbatim: session.archive[content: path])
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            Spacer()
        }
        
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
