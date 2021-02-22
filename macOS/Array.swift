import Foundation

extension Array {
    func transform(transform: (Self) -> Void) {
        transform(self)
    }
}
