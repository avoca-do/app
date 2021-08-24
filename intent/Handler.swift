import Intents
import Kanban

final class Handler: INExtension, PreviewIntentHandling, ProgressIntentHandling, ActivityIntentHandling {
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
    
    func resolveProject(for intent: PreviewIntent, with: @escaping (ProjectResolutionResult) -> Void) {
        resolve(intent.project, with: with)
    }
    
    func provideProjectOptionsCollection(for: PreviewIntent, with: @escaping (INObjectCollection<Project>?, Error?) -> Void) {
        provide(with)
    }
    
    func resolveColumn(for intent: PreviewIntent, with: @escaping (ColumnResolutionResult) -> Void) {
        guard
            let archive = Defaults.archive,
            !archive.isEmpty
        else {
            return with(.notRequired())
        }

        guard
            let project = intent.project,
            let column = intent.column,
            let projectId = project.identifier.flatMap(Int.init),
            projectId < archive.count,
            let columnId = column.identifier.flatMap(Int.init),
            columnId < archive[projectId].count
        else {
            return with(.confirmationRequired(with: .init(identifier: "0", display: archive[0][0].name)))
        }

        with(.success(with: column))
    }
    
    func provideColumnOptionsCollection(for intent: PreviewIntent, with: @escaping (INObjectCollection<Column>?, Error?) -> Void) {
        guard
            let archive = Defaults.archive,
            let project = intent.project,
            let id = project.identifier.flatMap(Int.init),
            id < archive.count
        else {
            return with(.init(items: []), nil)
        }

        with(.init(items: (0 ..< archive.count)
                    .map {
                        .init(identifier: "\($0)", display: archive[id][$0].name)
                    }), nil)
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
