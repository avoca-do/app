import WidgetKit

extension Progress {
    struct Entry: TimelineEntry, Equatable {
        static let placeholder = Self(id: 0, board: "Kanban", percentage: 0.65, date: .distantPast)
        static let empty = Self(id: 0, board: "", percentage: 0, date: .distantPast)
        
        let id: Int
        let board: String
        let percentage: Double
        let date: Date
    }
}
