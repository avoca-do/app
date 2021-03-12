import WidgetKit
import Kanban

extension Activity {
    struct Provider: IntentTimelineProvider {
        func placeholder(in: Context) -> Entry {
            .placeholder
        }

        func getSnapshot(for intent: ActivityIntent, in context: Context, completion: @escaping (Entry) -> ()) {
            completion(context.isPreview ? .placeholder : intent.project.map {
                Entry(board: $0.displayString, period: .month, values: [], date: .init())
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
                                        period: intent.period,
                                        values: archive[activity: Kanban.Period.allCases[max(intent.period.rawValue - 1, 0)]][id],
                                        date: .init())],
                             policy: .never))
        }
    }
}
