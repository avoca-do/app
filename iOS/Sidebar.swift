import SwiftUI

struct Sidebar: View {
    @Binding var session: Session
    
    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 20)
            ForEach(0 ..< session.archive.items.count, id: \.self) {
                Item(session: $session, index: $0)
            }
            Spacer()
                .frame(height: 20)
            NavigationLink(destination: link, isActive: .init(get: {
                session.board != nil
            }, set: {
                session.board = $0 ? 0 : nil
            })) {
                
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
                        session.board = 0
                    }
                }
        }
    }
    
    @ViewBuilder private var link: some View {
        if !(session.archive.isEmpty), let board = session.board {
            Project(session: $session, board: board)
        } else {
            Empty(session: $session)
        }
    }
}
