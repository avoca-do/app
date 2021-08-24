import SwiftUI
import WidgetKit

struct Progress: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: "Progress", intent: ProgressIntent.self, provider: Provider(), content: Content.init(entry:))
            .configurationDisplayName("Progress")
            .description("Project progress")
            .supportedFamilies([.systemSmall])
    }
}
