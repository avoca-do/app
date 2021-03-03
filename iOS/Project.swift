import SwiftUI

struct Project: View {
    @Binding var session: Session
    
    var body: some View {
        VStack(spacing: 0) {
            Title(session: $session)
            Board(session: $session)
            Paging(session: $session)
            Options(session: $session)
        }
    }
}
