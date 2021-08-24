import WidgetKit
import Kanban

extension Activity {
    struct Provider: IntentTimelineProvider {
        func placeholder(in: Context) -> Entry {
            .placeholder
        }

        func getSnapshot(for: ActivityIntent, in: Context, completion: @escaping (Entry) -> ()) {
            completion(.placeholder)
        }

        func getTimeline(for intent: ActivityIntent, in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            completion(.init(entries: [
                                Defaults
                                    .archive
                                    .flatMap { archive in
                                        intent
                                            .project
                                            .flatMap(\.identifier)
                                            .flatMap(Int.init)
                                            .map {
                                                archive[$0]
                                            }
                                    }
                                    .map {
                                        .init(name: $0.name,
                                              activity: $0.activity(period: .custom($0.start)),
                                              date: $0.start)
                                    }
                                ?? .placeholder], policy: .never))
        }
    }
}
