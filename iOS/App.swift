import SwiftUI
import Kanban

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .onReceive(Memory.shared.archive) {
                    guard $0.date(.archive) > session.archive.date(.archive) else { return }
                    UIApplication.shared.resign()
                    session.dismiss.send()
                    session.path = .archive
                    session.archive = $0
                }
        }
        .onChange(of: phase) {
            if $0 == .active {
                delegate.rate()
                Memory.shared.refresh()
            }
        }
    }
}
