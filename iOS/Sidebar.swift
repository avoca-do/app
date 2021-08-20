import SwiftUI

struct Sidebar: View {
    @Binding var session: Session
    @State private var detail = false
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                Spacer()
                    .frame(height: 20)
                ForEach(0 ..< session.archive.items.count, id: \.self) {
                    Item(session: $session, detail: $detail, index: $0)
                }
                Spacer()
                    .frame(height: 20)
                NavigationLink(destination: link, isActive: $detail) {
                    EmptyView()
                }
            }
        }
        .navigationBarTitle("Projects", displayMode: .large)
        .navigationBarItems(
            leading: Option(symbol: "slider.vertical.3") {
                session.modal.send(.settings)
            },
            trailing: HStack {
                Option(symbol: "chart.pie") {
                    session.modal.send(.activity)
                }
                Option(symbol: "magnifyingglass") {
                    
                }
                Option(symbol: "plus", action: session.newProject)
            })
        .onAppear {
            cloud
                .notifier
                .notify(queue: .main) {
                    if session.archive.isEmpty {
                        detail = true
                    }
                }
        }
    }
    
    @ViewBuilder private var link: some View {
        if let board = session.board {
            Project(session: $session, board: board)
        } else {
            Window.Empty(session: $session)
        }
    }
}
