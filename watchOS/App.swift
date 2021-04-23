import SwiftUI
import Kanban

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @Environment(\.scenePhase) private var phase
    @WKExtensionDelegateAdaptor(Delegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .onReceive(Repository.memory.archive) {
                    if $0.count(.archive) <= session.path._board {
                        session.path = .archive
                    }
                    session.archive = $0
                }
                .onAppear(perform: Repository.memory.pull.send)
        }
        .onChange(of: phase) {
            if $0 == .active {
                Repository.memory.pull.send()
            }
        }
    }
}
