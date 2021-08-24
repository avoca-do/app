import SwiftUI
import WidgetKit

struct Activity: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: "Activity", intent: ActivityIntent.self, provider: Provider(), content: Content.init(entry:))
            .configurationDisplayName("Activity")
            .description("Project activity")
            .supportedFamilies([.systemSmall])
    }
}
