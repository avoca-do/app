import SwiftUI

struct Window: View {
    @Binding var session: Session
    
    var body: some View {
        if session.path == .archive {
            HStack {
                Sidebar(session: $session)
                Spacer()
            }
        } else {
            
        }
    }
}
