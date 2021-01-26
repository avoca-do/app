import SwiftUI
import Kanban

@main struct App: SwiftUI.App {
    @State private var archive: Archive?
    
    var body: some Scene {
        WindowGroup {
            if archive == nil {
                Text("Loading")
            } else {
                Window(session: .init(archive: archive!))
            }
        }
    }
}
