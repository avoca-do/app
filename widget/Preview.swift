import SwiftUI
import WidgetKit

struct Preview: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: "Preview", intent: PreviewIntent.self, provider: Provider(), content: Content.init(entry:))
            .configurationDisplayName("Preview")
            .description("Project preview")
            .supportedFamilies([.systemSmall])
    }
}
