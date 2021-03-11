import SwiftUI
import WidgetKit
import Combine
import Kanban

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .ignoresSafeArea(.keyboard)
                .onReceive(Memory.shared.archive) {
                    guard $0.date(.archive) > session.archive.date(.archive) else { return }
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
                .onReceive(Memory.shared.save.debounce(for: .seconds(1), scheduler: DispatchQueue.main)) {
                    Defaults.archive = $0
                    WidgetCenter.shared.reloadAllTimelines()
                }
        }
        .onChange(of: phase) {
            if $0 == .active {
                Memory.shared.fetch()
            }
        }
    }
}
