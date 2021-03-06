import WidgetKit
import SwiftUI

struct Cards: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: "Cards", intent: ProjectIntent.self, provider: Provider()) { entry in
            Content(entry: entry)
        }
        .configurationDisplayName("Project")
        .description("Project overview")
    }
}
