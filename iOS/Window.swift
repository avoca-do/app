import SwiftUI

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        NavigationView {
            Sidebar(session: $session)
        }
    }
}
