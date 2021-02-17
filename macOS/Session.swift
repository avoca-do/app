import Foundation
import Combine
import Kanban

final class Session {
    static let shared = Session()
    let archive = CurrentValueSubject<Archive, Never>(.init())
    let dismiss = PassthroughSubject<Void, Never>()
    
    private init() { }
}
