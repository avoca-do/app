import WidgetKit
import SwiftUI

struct Actions: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: "Actions", intent: ProjectIntent.self, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("Search")
        .description("Search from Home")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
