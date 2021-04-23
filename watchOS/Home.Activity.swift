import SwiftUI
import Kanban

extension Home {
    struct Activity: View {
        @Binding var session: Session
        @State private var period = Period.month
        @State private var values = [[Double]]()
        @State private var hidden = Set<Int>()
        @State private var since = ""
        
        var body: some View {
            ScrollView {
                Picker("Period", selection: $period) {
                    Text("Year")
                        .tag(Period.year)
                    Text("Month")
                        .tag(Period.month)
                    Text("Week")
                        .tag(Period.week)
                    Text("Day")
                        .tag(Period.day)
                }
                .frame(height: 40)
                .padding(.bottom)
                Chart(hidden: $hidden, values: values)
                    .frame(height: 120)
                    .padding([.horizontal, .top])
                    .onAppear(perform: refresh)
                    .onChange(of: period) { _ in
                        refresh()
                    }
                ForEach(0 ..< session.archive.count(.archive), id: \.self) {
                    Chart.Item(session: $session, hidden: $hidden, index: $0)
                }
                Spacer()
                    .frame(height: 20)
            }
        }
        
        private func refresh() {
            values = session.archive[activity: period]
            since = RelativeDateTimeFormatter().localizedString(for: period.date, relativeTo: .init())
        }
    }

}
