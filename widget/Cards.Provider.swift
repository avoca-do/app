import WidgetKit
import Kanban

extension Cards {
    struct Provider: IntentTimelineProvider {
        func placeholder(in: Context) -> Entry {
            .placeholder
        }

        func getSnapshot(for intent: ProjectIntent, in context: Context, completion: @escaping (Entry) -> ()) {
            completion(context.isPreview ? .placeholder : intent.project.map {
                Entry(id: $0.identifier.flatMap(Int.init) ?? 0, board: $0.displayString, column: intent.column?.displayString ?? "", cards: [], date: .init())
            } ?? .empty)
        }

        func getTimeline(for intent: ProjectIntent, in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            guard
                let archive = Defaults.archive,
                let projectId = intent.project?.identifier.flatMap(Int.init),
                let columnId = intent.column?.identifier.flatMap(Int.init),
                let bottom = intent.bottom?.boolValue,
                projectId < archive.count(.archive),
                columnId < archive.count(.board(projectId))
            else {
                return completion(.init(entries: [.empty], policy: .never))
            }
            var cards = (0 ..< archive.count(.column(.board(projectId), columnId))).map {
                archive[content: .card(.column(.board(projectId), columnId), $0)]
            }
            if bottom {
                cards.reverse()
            }
            completion(.init(entries: [.init(
                                        id: projectId,
                                        board: archive[name: .board(projectId)],
                                        column: archive[title: .column(.board(projectId), columnId)],
                                        cards: cards,
                                        date: .init())],
                             policy: .never))
        }
    }
}
