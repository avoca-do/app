import Foundation
import Combine
import Kanban

struct Session {
    let path = PassthroughSubject<Path, Never>()
}
