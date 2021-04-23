import SwiftUI

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        if session.open {
            Project(session: $session)
        } else {
            Home(session: $session)
        }
    }
}
