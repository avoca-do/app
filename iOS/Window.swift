import SwiftUI

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            if session.board == nil {
                Home(session: $session)
                    .transition(.move(edge: .leading))
            } else {
                Board(session: $session)
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.4))
    }
}
