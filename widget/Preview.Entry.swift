import WidgetKit

extension Preview {
    struct Entry: TimelineEntry {
        static let placeholder = Entry(project: "Meaning of Life", column: "DO", cards: ["Find it", "Number 42"])
     
        let project: String
        let column: String
        let cards: [String]
        let date = Date()
    }
}
