import SwiftUI

struct Window: View {
    @Binding var session: Session
    @Namespace private var global
    
    var body: some View {
        ZStack {
            if session.selected {
                Board(session: $session, global: global)
            } else {
                Home(session: $session, global: global)
            }
        }
        .animation(.easeInOut(duration: 0.25))
    }
}
