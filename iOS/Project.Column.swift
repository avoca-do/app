import SwiftUI

extension Project {
    struct Column: View {
        @Binding var session: Session
        let board: Int
        let index: Int
        
        var body: some View {
            Button {
                session.column = index
            } label: {
                ZStack {
                    if session.column == index {
                        Capsule()
                            .fill(Color.accentColor)
                    }
                    Text(verbatim: session.archive[board][index].name)
                        .font(.callout)
                        .foregroundColor(session.column == index ? .white : .secondary)
                        .padding(.horizontal, 35)
                        .padding(.vertical, 8)
                }
                .fixedSize()
                .contentShape(Rectangle())
            }
        }
    }
}
