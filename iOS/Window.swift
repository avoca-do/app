import SwiftUI

struct Window: View {
    @Binding var session: Session
    @State private var board: Int?
    @Namespace private var global
    
    var body: some View {
        ZStack {
            if board == nil {
                Home(session: $session, global: global)
            } else {
                Board(session: $session, board: board!, global: global)
            }
        }
        .animation(.easeInOut(duration: 0.25))
        .onReceive(session.board) {
            board = $0
        }
    }
}
