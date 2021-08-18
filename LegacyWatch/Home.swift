import SwiftUI

struct Home: View {
    @Binding var session: Session
    
    var body: some View {
        TabView {
            Projects(session: $session)
            Activity(session: $session)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
