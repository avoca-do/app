import SwiftUI

extension Project {
    struct Column: View {
        @Binding var session: Session
        @Binding var current: Int
        let board: Int
        let index: Int
        
        var body: some View {
            Button {
                current = index
            } label: {
                ZStack {
                    if current == index {
                        Capsule()
                            .fill(Color(.secondarySystemFill))
                    }
                    Text(verbatim: session.archive[board][index].name)
                        .font(.footnote)
                        .foregroundColor(current == index ? .primary : .secondary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 7)
                }
                .fixedSize()
                .contentShape(Rectangle())
            }
        }
    }
}
