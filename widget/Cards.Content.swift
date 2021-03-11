import SwiftUI

extension Cards {
    struct Content: View {
        let entry: Entry
        
        var body: some View {
            if entry == .empty {
                VStack(alignment: .leading) {
                    Text("No projects yet or configuration needed")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text("Edit widget for more details")
                        .font(.footnote)
                        .foregroundColor(.accentColor)
                }
                .padding()
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            } else {
                VStack {
                    Text(verbatim: entry.board)
                    Text(verbatim: entry.column)
                    ForEach(entry.cards, id: \.self) {
                        Text(verbatim: $0)
                    }
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            }
        }
    }
}
