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
        wave(Int),
        edit(Int),
        write(Write)
    }
}
