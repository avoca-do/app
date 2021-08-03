import Foundation
import Combine
import Kanban

struct Session {
    let path = CurrentValueSubject<Path, Never>(.archive)
    let card = PassthroughSubject<Bool, Never>()
}
