import SwiftUI

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            if session.board == nil {
                Home(session: $session)
            } else {
                Board(session: $session)
            }
        }
    }
}
