import Foundation
import Combine

struct Session {
    var board: Board?
    var typing = false
    let become = PassthroughSubject<Void, Never>()
}
