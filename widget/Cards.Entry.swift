import WidgetKit

extension Cards {
    struct Entry: TimelineEntry, Equatable {
        static let placeholder = Self(id: 0, board: "Kanban", column: "Doing", cards: ["12345678901234567890", "12341234567890", "12345671234567890", "121234567890", "123456781234567890"], date: .distantPast)
        static let empty = Self(id: 0, board: "", column: "", cards: [], date: .distantPast)
        
        let id: Int
        let board: String
        let column: String
        let cards: [String]
        let date: Date
    }
}
