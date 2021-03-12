import WidgetKit
import SwiftUI

struct Progress: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: "Progress", intent: ProgressIntent.self, provider: Provider()) { entry in
            Content(entry: entry)
        }
        .configurationDisplayName("Progress")
        .description("Progress overview")
    }
}
