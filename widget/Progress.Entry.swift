import WidgetKit

extension Progress {
    struct Entry: TimelineEntry {
        static let placeholder = Entry(name: "Meaning of Life", percentage: 0.42)
     
        let name: String
        let percentage: Double
        let date = Date()
    }
}
