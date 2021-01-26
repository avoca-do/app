import SwiftUI
import Kanban

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .onReceive(Memory.shared.archive) {
                    session.archive = $0
                }
        }
        .onChange(of: phase) {
            if $0 == .active {
                Memory.shared.refresh()
            }
        }
    }
}
