import SwiftUI

extension Preview {
    struct Content: View {
        let entry: Entry
        
        var body: some View {
            GeometryReader { _ in
                VStack {
                    Group {
                        Text(verbatim: entry.project + " : ")
                            .foregroundColor(.primary)
                            .kerning(1)
                        + Text(verbatim: entry.column)
                            .foregroundColor(.secondary)
                            .kerning(1)
                    }
                    .font(.caption)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    ForEach(0 ..< entry.cards.count, id: \.self) { index in
                        Group {
                            Text(verbatim: "— ")
                                .foregroundColor(.accentColor)
                                .font(.caption)
                            + Text(verbatim: entry.cards[index])
                                .foregroundColor(.secondary)
                                .kerning(1)
                                .font(.caption2)
                        }
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                }
                .padding([.top, .leading, .trailing])
            }
        }
    }
}
