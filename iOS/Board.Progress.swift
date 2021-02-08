import SwiftUI

extension Board {
    struct Progress: View {
        @Binding var session: Session
        let board: Int
        
        var body: some View {
            VStack {
                Title(session: $session, title: session[board].name)
                Spacer()
            }
        }
    }
}
