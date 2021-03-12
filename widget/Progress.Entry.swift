import WidgetKit

extension Progress {
    struct Entry: TimelineEntry, Equatable {
        static let placeholder = Self(board: "Kanban", percentage: 0.65, date: .distantPast)
        static let empty = Self(board: "", percentage: 0, date: .distantPast)
        
        let board: String
        let percentage: Double
        let date: Date
    }
}
