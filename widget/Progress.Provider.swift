import WidgetKit
import Kanban

extension Progress {
    struct Provider: IntentTimelineProvider {
        func placeholder(in: Context) -> Entry {
            .placeholder
        }

        func getSnapshot(for: ProgressIntent, in: Context, completion: @escaping (Entry) -> ()) {
            completion(.placeholder)
        }

        func getTimeline(for intent: ProgressIntent, in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
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
                                              percentage: $0.progress.percentage)
                                    }
                                ?? .placeholder], policy: .never))
        }
    }
}
