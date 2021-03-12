import WidgetKit
import SwiftUI

struct Cards: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: "Cards", intent: ProjectIntent.self, provider: Provider()) { entry in
            Content(entry: entry)
        }
        .configurationDisplayName("Project")
        .description("Keep track of 1 project")
    }
}
