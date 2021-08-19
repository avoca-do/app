import Foundation

extension App {
    enum Modal: Identifiable, Equatable {
        var id: String {
            "\(self)"
        }
        
        case
        purchase,
        store,
        write(Write)
    }
}