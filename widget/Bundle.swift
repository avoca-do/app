import SwiftUI
import WidgetKit

@main struct Bundle: WidgetBundle {
    @WidgetBundleBuilder var body: some Widget {
        C()
    }
}


#warning("boilerplate")


struct C: Widget {
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: "", intent: ProjectIntent.self, provider: Provider()) { entry in
            Circle()
        }
    }
}


struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> Entry {
        .init(date: .init())
    }
    
        func getSnapshot(for intent: ProjectIntent, in context: Context, completion: @escaping (Entry) -> ()) {

        }

        func getTimeline(for intent: ProjectIntent, in: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        }
    }


struct Entry: TimelineEntry {
        
        let date: Date
    }
