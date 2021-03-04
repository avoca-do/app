import SwiftUI

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        if session.open {
            Project(session: $session)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
        } else {
            HStack {
                Sidebar(session: $session)
                ZStack {
                    RoundedRectangle(cornerRadius: Metrics.corners)
                        .fill(Color(.secondarySystemBackground))
                    switch session.section {
                    case .projects:
                        Middlebar(session: $session)
                    case .capacity:
                        Capacity(session: $session)
                    case .settings:
                        Settings(session: $session)
                    }
                }
            }
            .padding()
            .transition(.move(edge: .leading))
        }
    }
}
