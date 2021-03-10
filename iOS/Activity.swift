import SwiftUI
import Kanban

struct Activity: View {
    @Binding var session: Session
    @State private var period = Period.week
    @State private var values = [[Double]]()
    @State private var hidden = Set<Int>()
    @State private var since = ""
    
    var body: some View {
        ScrollView {
            Text("Activity")
                .bold()
                .padding([.leading, .top])
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            Picker("", selection: $period) {
                Text("Year")
                    .tag(Period.year)
                Text("Month")
                    .tag(Period.month)
                Text("Week")
                    .tag(Period.week)
                Text("Day")
                    .tag(Period.day)
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .padding([.horizontal, .bottom])
            Chart(hidden: $hidden, values: values)
                .frame(height: 160)
                .padding([.horizontal, .top])
                .onAppear(perform: refresh)
                .onChange(of: period) { _ in
                    refresh()
                }
            HStack {
                Text(verbatim: since)
                Spacer()
                Text("Now")
            }
            .foregroundColor(.secondary)
            .font(.footnote)
            .padding(.horizontal)
            .padding(.top, 3)
            .padding(.bottom, 30)
            ForEach(0 ..< session.archive.count(.archive), id: \.self) {
                Item(session: $session, hidden: $hidden, index: $0)
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
