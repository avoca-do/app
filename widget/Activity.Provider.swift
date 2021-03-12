import WidgetKit
import Kanban

extension Activity {
    struct Provider: IntentTimelineProvider {
        func placeholder(in: Context) -> Entry {
            .placeholder
        }

        func getSnapshot(for intent: ActivityIntent, in context: Context, completion: @escaping (Entry) -> ()) {
            completion(context.isPreview ? .placeholder : intent.project.map {
                Entry(board: $0.displayString, values: [], date: .init())
            } ?? .empty)
        }

        func getTimeline(for intent: ActivityIntent, in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            guard
                let archive = Defaults.archive,
                let id = intent.project?.identifier.flatMap(Int.init),
                id < archive.count(.archive)
            else {
                return completion(.init(entries: [.empty], policy: .never))
            }
            completion(.init(entries: [.init(
                                        board: archive[name: .board(id)],
                                        values: archive[activity: Kanban.Period.allCases[intent.period.rawValue]][id],
                                        date: .init())],
                             policy: .never))
        }
    }
}
