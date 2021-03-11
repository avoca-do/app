import Intents

final class Handler: INExtension, ProjectIntentHandling {
    func resolveProject(for: ProjectIntent, with: @escaping (ProjectResolutionResult) -> Void) {
        
    }
    
    func provideProjectOptionsCollection(for: ProjectIntent, with: @escaping (INObjectCollection<Project>?, Error?) -> Void) {
        with(.init(items: [.init(identifier: "0", display: "First")]), nil)
    }
}
