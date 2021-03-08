import SwiftUI
import Kanban

struct Activity: View {
    @Binding var session: Session
    @State private var period = Period.week
    @State private var values = [[Double]]()
    @State private var since = ""
    
    var body: some View {
        Chart(values: values, since: since)
            .onAppear(perform: refresh)
            .onChange(of: period) { _ in
                refresh()
            }
    }
    
    private func refresh() {
        values = session.archive[activity: period]
        since = RelativeDateTimeFormatter().localizedString(for: period.date, relativeTo: .init())
    }
}
