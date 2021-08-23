import SwiftUI
import Archivable

let cloud = Cloud.new
let purchases = Purchases()

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @State private var modal: Modal?
    @Environment(\.scenePhase) private var phase
    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Sidebar(session: $session)
                Empty(session: $session)
            }
            .sheet(item: $modal, content: modal)
            .onReceive(cloud.archive) {
                session.archive = $0
            }
            .onReceive(session.modal) {
                change($0)
            }
//                .onReceive(purchases.open) {
//                    change(.store)
//                }
//                .onReceive(delegate.froob) {
//                    change(.froob)
//                }
        }
        .onChange(of: phase) {
            if $0 == .active {
                cloud.pull.send()
            }
        }
    }
    
    private func change(_ new: Modal) {
        guard new != modal else { return }
        if modal == nil {
            modal = new
        } else {
            modal = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                modal = new
            }
        }
    }
    
    @ViewBuilder private func modal(_ modal: Modal) -> some View {
        switch modal {
        case let .write(write):
            Writer(session: $session, write: write)
        case let .edit(board):
            Project.Edit(session: $session, board: board)
        case let .wave(board):
            Wave(session: $session, board: board)
        case let .stats(board):
            Stats(session: $session, board: board, progress: session.archive[board].progress)
        case let .card(path):
            Project.Card.Edit(session: $session, path: path)
        case .purchase:
            Purchase(session: $session)
        case .store:
            Store(session: $session)
        case .settings:
            Settings(session: $session)
        case .activity:
            Activity(session: $session)
        }
    }
}
