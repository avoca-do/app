import SwiftUI
import Archivable
import Kanban

let cloud = Cloud.new

@main struct App: SwiftUI.App {
    @State private var archive = Archive.new
    @Environment(\.scenePhase) private var phase
    @WKExtensionDelegateAdaptor(Delegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            Sidebar(archive: archive)
                .onReceive(cloud.archive) {
                    archive = $0
                }
                .onAppear {
                    cloud.pull.send()
                }
        }
        .onChange(of: phase) {
            switch $0 {
            case .active:
                cloud.pull.send()
            default:
                break
            }
        }
    }
}
