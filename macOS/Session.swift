import Foundation
import Combine
import Kanban

final class Session {
    static let shared = Session()
    let archive = CurrentValueSubject<Archive, Never>(.init())
    let path = CurrentValueSubject<Path, Never>(.archive)
    
    private init() { }
}
