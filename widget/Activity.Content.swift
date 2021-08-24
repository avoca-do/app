import SwiftUI

extension Activity {
    struct Content: View {
        let entry: Entry
        
        var body: some View {
            ZStack {
                Chart(values: entry.activity)
                    .padding(14)
                VStack {
                    Text(verbatim: entry.name)
                        .font(.caption2)
                    Spacer()
                    Text(verbatim: RelativeDateTimeFormatter().string(from: entry.date))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(12)
        }
    }
}
