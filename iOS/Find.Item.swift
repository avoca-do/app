import SwiftUI

extension Find {
    struct Item: View {
        let content: String
        let breadcrumbs: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Group {
                    Text(verbatim: content)
                        .foregroundColor(.primary)
                        .font(.footnote)
                    + Text(verbatim: (breadcrumbs.isEmpty ? "" : "\n") + breadcrumbs)
                        .foregroundColor(.secondary)
                        .kerning(1)
                        .font(.caption2)
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding()
            }
        }
    }
}
