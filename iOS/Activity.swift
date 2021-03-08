import SwiftUI
import Kanban

struct Activity: View {
    @Binding var session: Session
    @State private var period = Period.week
    @State private var values = [[Double]]()
    @State private var since = ""
    
    var body: some View {
        VStack {
            Text("Activity")
                .bold()
                .padding([.leading, .top])
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            Picker("", selection: $period) {
                Text("Hour")
                    .foregroundColor(.white)
                    .tag(Period.hour)
                Text("Day")
                    .foregroundColor(.white)
                    .tag(Period.day)
                Text("Week")
                    .foregroundColor(.white)
                    .tag(Period.week)
                Text("Month")
                    .foregroundColor(.white)
                    .tag(Period.month)
                Text("Year")
                    .foregroundColor(.white)
                    .tag(Period.year)
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .padding(.horizontal)
            Chart(values: values, since: since)
                .onAppear(perform: refresh)
                .onChange(of: period) { _ in
                    refresh()
                }
            Spacer()
        }
    }
    
    private func refresh() {
        withAnimation(.easeInOut(duration: 1)) {
            values = session.archive[activity: period]
            since = RelativeDateTimeFormatter().localizedString(for: period.date, relativeTo: .init())
        }
    }
}
