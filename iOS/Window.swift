import SwiftUI

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            if session.board == nil {
                Home(session: $session)
            } else {
                Board(session: $session)
            }
        }
    }
}
