import SwiftUI
import Archivable

let cloud = Cloud.new
//let purchases = Purchases()

@main struct App: SwiftUI.App {
    @State private var session = Session()
    @Environment(\.scenePhase) private var phase
//    @UIApplicationDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            Window(session: $session)
                .sheet(item: $session.modal, content: modal)
                .onReceive(cloud.archive) {
                    session.archive = $0
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
    
    private func change(_ modal: Session.Modal) {
        guard modal != session.modal else { return }
        if session.modal == nil {
            session.modal = modal
        } else {
            session.modal = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                session.modal = modal
            }
        }
    }
    
    @ViewBuilder private func modal(_ modal: Session.Modal) -> some View {
//        switch modal {
//        case let .bookmarks(id), let .history(id):
//            Collection(session: $session, id: id, modal: modal)
//        case let .info(id):
//            Tab.Info(session: $session, id: id)
//        case let .options(id):
//            Tab.Options(session: $session, id: id)
//        case .settings:
//            Settings(session: $session)
//        case .trackers:
//            Trackers(session: $session)
//        case .activity:
//            Activity(session: $session)
//        case .froob:
//            Info.Froob(session: $session)
//        case .store:
//            Store()
//        }
    }
}
