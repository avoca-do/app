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
                            .fill(Color.accentColor)
                    }
                    Text(verbatim: session.archive[board][index].name)
                        .font(.callout)
                        .foregroundColor(current == index ? .white : .secondary)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 8)
                }
                .fixedSize()
                .contentShape(Rectangle())
            }
        }
    }
}
