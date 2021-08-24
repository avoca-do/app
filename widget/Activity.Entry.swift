import WidgetKit

extension Activity {
    struct Entry: TimelineEntry {
        static let placeholder = Entry(name: "Preview", activity: [0.3, 0.2, 0.4, 0.5, 0.6, 0.5, 0.7, 0.7, 0.8, 0.9], date: .init())
     
        let name: String
        let activity: [Double]
        let date: Date
    }
}
