import Foundation
import Combine

struct Session {
    var typing = false
    let become = PassthroughSubject<Void, Never>()
}
