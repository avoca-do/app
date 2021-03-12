import SwiftUI

extension Activity {
    struct Content: View {
        let entry: Entry
        
        var body: some View {
            if entry == .empty {
                Text("Edit widget to continue")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                VStack(alignment: .leading) {
                    Text(verbatim: entry.board)
                        .font(.callout)
                    Chart(values: entry.values)
                        .padding(.vertical)
                    Text(title)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding(24)
            }
        }
        
        private var title: String {
            switch entry.period {
            case .month: return "This month"
            case .week: return "This week"
            case .day: return "Today"
            default: return "This year"
            }
        }
    }
}
