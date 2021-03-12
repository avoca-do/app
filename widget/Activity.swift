import WidgetKit
import SwiftUI

struct Activity: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: "Activity", intent: ActivityIntent.self, provider: Provider()) { entry in
            Content(entry: entry)
        }
        .configurationDisplayName("Activity")
        .description("Activity overview")
        .supportedFamilies([.systemLarge])
    }
}
