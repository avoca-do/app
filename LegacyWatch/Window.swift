import SwiftUI
import Kanban

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        if session.path == .archive {
            Home(session: $session)
        } else {
            Project(session: $session)
        }
    }
}
