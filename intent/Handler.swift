import Intents
import Kanban

final class Handler: INExtension, ProjectIntentHandling, ProgressIntentHandling, ActivityIntentHandling {
    func resolveProject(for intent: ActivityIntent, with: @escaping (ProjectResolutionResult) -> Void) {
        resolve(intent.project, with: with)
    }
    
    func provideProjectOptionsCollection(for: ActivityIntent, with: @escaping (INObjectCollection<Project>?, Error?) -> Void) {
        provide(with)
    }
    
    func resolveProject(for intent: ProgressIntent, with: @escaping (ProjectResolutionResult) -> Void) {
        resolve(intent.project, with: with)
    }
    
    func provideProjectOptionsCollection(for: ProgressIntent, with: @escaping (INObjectCollection<Project>?, Error?) -> Void) {
        provide(with)
    }
    
    
    
    
    
    
    func resolveProject(for intent: ProjectIntent, with: @escaping (ProjectResolutionResult) -> Void) {
        resolve(intent.project, with: with)
    }
    
    func provideProjectOptionsCollection(for: ProjectIntent, with: @escaping (INObjectCollection<Project>?, Error?) -> Void) {
        provide(with)
    }
    
    func resolveColumn(for intent: ProjectIntent, with: @escaping (ColumnResolutionResult) -> Void) {
//        guard
//            let archive = self.archive,
//            !archive.isEmpty(.archive)
//        else {
//            return with(.notRequired())
//        }
//
//        guard
//            let project = intent.project,
//            let column = intent.column,
//            let projectId = project.identifier.flatMap(Int.init),
//            projectId < archive.count(.archive),
//            let columnId = column.identifier.flatMap(Int.init),
//            columnId < archive.count(.board(projectId))
//        else {
//            return with(.confirmationRequired(with: .init(identifier: "0", display: archive[title: .column(.board(0), 0)])))
//        }
//
//        with(.success(with: column))
    }
    
    func provideColumnOptionsCollection(for intent: ProjectIntent, with: @escaping (INObjectCollection<Column>?, Error?) -> Void) {
//        guard
//            let archive = archive,
//            let project = intent.project,
//            let id = project.identifier.flatMap(Int.init),
//            id < archive.count(.archive)
//        else {
//            return with(.init(items: []), nil)
//        }
//
//        with(.init(items: (0 ..< archive.count(.board(id))).map {
//            .init(identifier: "\($0)", display: archive[title: .column(.board(id), $0)])
//        }), nil)
    }
    
    func resolveBottom(for intent: ProjectIntent, with: @escaping (INBooleanResolutionResult) -> Void) {
        with(.success(with: intent.bottom?.boolValue ?? false))
    }
    
    private func resolve(_ project: Project?, with: @escaping (ProjectResolutionResult) -> Void) {
        guard
            let archive = Defaults.archive,
            !archive.isEmpty
        else {
            return with(.notRequired())
        }

        guard
            let project = project,
            let id = project.identifier.flatMap(Int.init),
            id < archive.count
        else {
            return with(.confirmationRequired(with: .init(identifier: "0", display: archive[0].name)))
        }

        with(.success(with: project))
    }
    
    private func provide(_ with: @escaping (INObjectCollection<Project>?, Error?) -> Void) {
        with(.init(items: Defaults
                    .archive
                    .map { archive in
                        (0 ..< archive.count)
                            .map {
                                .init(identifier: "\($0)", display: archive[$0].name)
                            }
                    } ?? []), nil)
    }
}
