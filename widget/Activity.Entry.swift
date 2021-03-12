import WidgetKit

extension Activity {
    struct Entry: TimelineEntry, Equatable {
        static let placeholder = Self(id: 0, board: "Kanban", period: .month, values: [0, 0.2, 0.25, 0.3, 0.75], date: .distantPast)
        static let empty = Self(id: 0, board: "", period: .month, values: [], date: .distantPast)
        
        let id: Int
        let board: String
        let period: Period
        let values: [Double]
        let date: Date
    }
}
