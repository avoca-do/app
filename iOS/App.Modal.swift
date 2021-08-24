import Foundation
import Kanban

extension App {
    enum Modal: Identifiable, Equatable {
        var id: String {
            "\(self)"
        }
        
        case
        purchase,
        store,
        settings,
        activity,
        find,
        edit(Int),
        card(Path),
        wave(Int),
        stats(Int),
        write(Write)
    }
}
