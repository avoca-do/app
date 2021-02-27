import SwiftUI

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        if session.path == .archive {
            HStack {
                Sidebar(session: $session)
                switch session.section {
                case .projects: Middlebar(session: $session)
                case .capacity:
                    Rectangle()
                case .settings:
                    RoundedRectangle(cornerRadius: Metrics.corners)
                }
            }
            .padding()
        } else {
            
        }
    }
}
