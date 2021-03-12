import WidgetKit
import Kanban

extension Progress {
    struct Provider: IntentTimelineProvider {
        func placeholder(in: Context) -> Entry {
            .placeholder
        }

        func getSnapshot(for intent: ProgressIntent, in context: Context, completion: @escaping (Entry) -> ()) {
            completion(context.isPreview ? .placeholder : intent.project.map {
                Entry(id: $0.identifier.flatMap(Int.init) ?? 0, board: $0.displayString, percentage: 0, date: .init())
            } ?? .empty)
        }

        func getTimeline(for intent: ProgressIntent, in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            guard
                let archive = Defaults.archive,
                let id = intent.project?.identifier.flatMap(Int.init),
                id < archive.count(.archive)
            else {
                return completion(.init(entries: [.empty], policy: .never))
            }
            completion(.init(entries: [.init(
                                        id: id,
                                        board: archive[name: .board(id)],
                                        percentage: archive.progress(.board(id)).percentage,
                                        date: .init())],
                             policy: .never))
        }
    }
}
