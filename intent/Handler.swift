import Intents
import Kanban

final class Handler: INExtension, ProjectIntentHandling {
    private let archive = Defaults.archive
    
    func resolveProject(for intent: ProjectIntent, with: @escaping (ProjectResolutionResult) -> Void) {
        guard
            let archive = self.archive,
            !archive.isEmpty(.archive)
        else {
            return with(.notRequired())
        }
        
        guard
            let project = intent.project,
            let id = project.identifier.flatMap(Int.init),
            id < archive.count(.archive)
        else {
            return with(.confirmationRequired(with: .init(identifier: "0", display: archive[name: .board(0)])))
        }
        
        return with(.success(with: project))
    }
    
    func provideProjectOptionsCollection(for: ProjectIntent, with: @escaping (INObjectCollection<Project>?, Error?) -> Void) {
        with(.init(items: archive.map { archive in
            (0 ..< archive.count(.archive)).map {
                .init(identifier: "\($0)", display: archive[name: .board($0)])
            }
        } ?? []), nil)
    }
}
