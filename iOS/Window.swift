import SwiftUI

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        switch session.section {
        case .projects:
            Projects(session: $session)
        }
    }
}
