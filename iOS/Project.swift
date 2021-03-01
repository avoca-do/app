import SwiftUI

struct Project: View {
    @Binding var session: Session
    
    var body: some View {
        Title(session: $session)
        TabView {
            Tab()
            Tab()
            Tab()
        }
        .tabViewStyle(PageTabViewStyle())
        .edgesIgnoringSafeArea(.horizontal)
        Options(session: $session)
    }
}
