import SwiftUI

struct Window: View {
    @Binding var session: Session
    @State private var board: Int?
    @Namespace private var animation
    
    var body: some View {
        Group {
            if board == nil {
                Home(session: $session, animation: animation)
            } else {
                Board(session: $session, board: board!, animation: animation)
            }
        }
        .animation(.easeInOut(duration: 0.4))
        .onReceive(session.board) {
            board = $0
        }
    }
}
