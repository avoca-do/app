import WidgetKit
import Kanban

extension Preview {
    struct Provider: IntentTimelineProvider {
        func placeholder(in: Context) -> Entry {
            .placeholder
        }

        func getSnapshot(for: PreviewIntent, in: Context, completion: @escaping (Entry) -> ()) {
            completion(.placeholder)
        }

        func getTimeline(for intent: PreviewIntent, in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
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
                                    .map { project in
                                        { column in
                                            Entry(project: project.name, column: project[column].name, cards: project[column]
                                                    .items
                                                    .prefix(5)
                                                    .map(\.content))
                                        } (intent
                                            .column
                                            .flatMap(\.identifier)
                                            .flatMap(Int.init) ?? 0)
                                    }
                                ?? .placeholder], policy: .never))
        }
    }
}
