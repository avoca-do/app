import SwiftUI

struct Board: View {
    @Binding var session: Session
    let board: Int
    let global: Namespace.ID
    @State private var fold = Set<Int>()
    @Namespace private var local
    
    var body: some View {
        Bar(session: $session, fold: $fold, board: board, global: global, local: local)
        Content(session: $session, fold: $fold, board: board, global: global)
        Menu(session: $session, fold: $fold, board: board, local: local)
    }
}
