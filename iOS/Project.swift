import SwiftUI

struct Project: View {
    @Binding var session: Session
    @State private var tab = 0
    @State private var count = 1
    
    var body: some View {
        Title(session: $session)
        TabView(selection: $tab) {
            ForEach(0 ..< count, id: \.self) {
                Tab(session: $session, path: .column(session.path, $0))
                    .tag($0)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .edgesIgnoringSafeArea(.horizontal)
        Options(session: $session)
            .onAppear(perform: refresh)
            .onChange(of: session.path) { _ in
                refresh()
            }
    }
    
    private func refresh() {
        tab = 0
        switch session.path {
        case .board: count = session.archive.count(session.path)
        default: count = 1
        }
    }
}
