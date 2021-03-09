import SwiftUI
import Kanban

struct Activity: View {
    @Binding var session: Session
    @State private var period = Period.week
    @State private var values = [[Double]]()
    
    var body: some View {
        ScrollView {
            Text("Activity")
                .bold()
                .padding([.leading, .top])
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            Picker("", selection: $period) {
                Text("Day")
                    .tag(Period.day)
                Text("Week")
                    .tag(Period.week)
                Text("Month")
                    .tag(Period.month)
                Text("Year")
                    .tag(Period.year)
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .padding(.horizontal)
            Chart(values: values)
                .frame(height: 250)
                .padding()
                .onAppear(perform: refresh)
                .onChange(of: period) { _ in
                    refresh()
                }
        }
    }
    
    private func refresh() {
        withAnimation(.easeInOut(duration: 1)) {
            values = session.archive[activity: period]
        }
    }
}
