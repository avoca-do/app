import SwiftUI
import Kanban

struct Activity: View {
    @Binding var session: Session
    @State private var period = Period.month
    
    var body: some View {
        Popup(title: "General Activity", leading: { }) {
            VStack(spacing: 0) {
                Picker("Period", selection: $period) {
                    Text(verbatim: "Year")
                        .tag(Period.year)
                    Text(verbatim: "Month")
                        .tag(Period.month)
                    Text(verbatim: "Week")
                        .tag(Period.week)
                    Text(verbatim: "Day")
                        .tag(Period.day)
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top)
                Spacer()
                Chart(values: cloud.archive.value.activity(period: period))
                    .frame(height: 200)
                    .padding(.horizontal)
                    .padding(.bottom)
                HStack {
                    Text(verbatim: RelativeDateTimeFormatter().string(from: period.date))
                    Rectangle()
                        .frame(height: 1)
                    Text("Now")
                }
                .font(.footnote)
                .foregroundColor(.primary.opacity(0.2))
                .padding(.horizontal)
                Spacer()
            }
        }
    }
}
