import SwiftUI
import Kanban

struct Activity: View {
    let archive: Archive
    let board: Int
    
    var body: some View {
        Chart(values: archive.activity(period: .custom(archive[board].start)))
            .navigationTitle(RelativeDateTimeFormatter().string(from: archive[board].start))
    }
}
