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
                            .fill(Color(.tertiarySystemFill))
                    }
                    Text(verbatim: session.archive[board][index].name)
                        .font(.footnote)
                        .foregroundColor(current == index ? .primary : .secondary)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 6)
                }
                .fixedSize()
            }
        }
    }
}
