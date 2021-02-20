import Foundation
import Combine
import Kanban

final class Session {
    static var archive: Archive {
        _archive.value
    }
    
    static var path: Path {
        get {
            _path.value
        }
        set {
            _path.value = newValue
        }
    }
    
    static var archiving: AnyPublisher<Archive, Never> {
        _archive.eraseToAnyPublisher()
    }
    
    static var pathing: AnyPublisher<Path, Never> {
        _path.eraseToAnyPublisher()
    }
    
    static let middlebarScroll = PassthroughSubject<Void, Never>()
    
    static func mutate(transform: (inout Archive) -> Void) {
        var archive = self.archive
        transform(&archive)
        _archive.value = archive
    }
    
    private static let _archive = CurrentValueSubject<Archive, Never>(.init())
    private static let _path = CurrentValueSubject<Path, Never>(.archive)
}
