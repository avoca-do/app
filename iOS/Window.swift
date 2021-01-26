import SwiftUI

struct Window: View {
    @Binding var session: Session
    @State private var board: Int?
    
    var body: some View {
        Group {
            if board == nil {
                Home(session: $session)
                    .transition(.move(edge: .bottom))
            } else {
                Board(session: $session, board: board!)
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.4))
        .onReceive(session.board) {
            board = $0
        }
    }
}
