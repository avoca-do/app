import SwiftUI

struct Window: View {
    @State var session: Session
    @State private var board: Int?
    
    var body: some View {
        ZStack {
            if board == nil {
                Home(session: $session)
                    .transition(.move(edge: .leading))
            } else {
                Board(session: $session, board: board!)
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.4))
        .onReceive(session.board) {
            board = $0
        }
    }
}
