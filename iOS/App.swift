import SwiftUI
import Kanban

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .ignoresSafeArea(.keyboard)
                .onOpenURL { url in
                    switch url.scheme {
                    case "avocado":
                        UIApplication.shared.resign()
                        session.dismiss.send()
                        if let board = Int(url.absoluteString.dropFirst(10)),
                           session.archive.count(.archive) > board {
                            session.path = .column(.board(board), 0)
                            session.section = .projects
                            session.open = true
                        }
                    default: break
                    }
                }
                .onReceive(Repository.memory.archive) {
                    UIApplication.shared.resign()
                    session.dismiss.send()
                    if $0.count(.archive) > session.path._board {
                        session.path = .column(.board(session.path._board), 0)
                    } else {
                        session.open = false
                    }
                    session.archive = $0
                }
                .onReceive(session.purchases.open) {
                    UIApplication.shared.resign()
                    session.dismiss.send()
                    session.open = false
                    session.section = .capacity
                }
                .onReceive(session.purchases.plusOne) {
                    session.archive.capacity += 1
                }
        }
        .onChange(of: phase) {
            if $0 == .active {
                Repository.memory.pull.send()
            }
        }
    }
}
