import WidgetKit

extension Activity {
    struct Entry: TimelineEntry, Equatable {
        static let placeholder = Self(board: "Kanban", values: [0, 0.2, 0.25, 0.3, 0.75], date: .distantPast)
        static let empty = Self(board: "", values: [], date: .distantPast)
        
        let board: String
        let values: [Double]
        let date: Date
    }
}
