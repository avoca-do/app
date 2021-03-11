import WidgetKit

extension Cards {
    struct Entry: TimelineEntry {
        static let placeholder = Entry(board: "Kanban", column: "Doing", cards: ["A", "B", "C"], date: .distantPast)
        static let empty = Entry(board: "", column: "", cards: [], date: .distantPast)
        
        let board: String
        let column: String
        let cards: [String]
        let date: Date
    }
}
