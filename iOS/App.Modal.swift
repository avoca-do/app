import Foundation

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
        edit(Int),
        wave(Int),
        stats(Int),
        write(Write)
    }
}
