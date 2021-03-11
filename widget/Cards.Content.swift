import SwiftUI

extension Cards {
    struct Content: View {
        let entry: Entry
        
        var body: some View {
            VStack {
                Text(verbatim: entry.board)
                Text(verbatim: entry.column)
                ForEach(entry.cards, id: \.self) {
                    Text(verbatim: $0)
                }
                Spacer()
            }
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            .padding()
        }
    }
}
