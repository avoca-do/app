import SwiftUI
import Kanban

@main struct App: SwiftUI.App {
    @State private var archive: Archive?
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            Group {
                if archive == nil {
                    Text("Avocado")
                } else {
                    Window(session: .init(archive: archive!))
                }
            }
            .onReceive(Memory.shared.archive) {
                archive = $0
            }
        }
        .onChange(of: phase) {
            if $0 == .active {
                Memory.shared.refresh()
            }
        }
    }
}
