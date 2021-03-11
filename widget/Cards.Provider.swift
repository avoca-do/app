import WidgetKit
import Kanban

extension Cards {
    struct Provider: IntentTimelineProvider {
        func placeholder(in: Context) -> Entry {
            .placeholder
        }

        func getSnapshot(for intent: ProjectIntent, in context: Context, completion: @escaping (Entry) -> ()) {
            completion(context.isPreview ? .placeholder : intent.project.map {
                Entry(board: $0.displayString, column: "", cards: [], date: .init())
            } ?? .empty)
        }

        func getTimeline(for intent: ProjectIntent, in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            guard
                let archive = Defaults.archive,
                let id = intent.project?.identifier.flatMap(Int.init),
                id < archive.count(.archive)
            else {
                return completion(.init(entries: [.empty], policy: .never))
            }
            completion(.init(entries: [.init(board: archive[name: .board(id)], column: "", cards: [], date: .init())], policy: .never))
        }
    }
}
