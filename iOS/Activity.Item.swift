import SwiftUI

extension Activity {
    struct Item: View {
        @Binding var session: Session
        @Binding var hidden: Set<Int>
        let index: Int
        
        var body: some View {
            Button {
                if hidden.contains(index) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        _ = hidden.remove(index)
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        _ = hidden.insert(index)
                    }
                }
            } label: {
                HStack {
                    Circle()
                        .fill(hidden.contains(index) ? .init(.tertiaryLabel) : Color.index(index))
                        .opacity(hidden.contains(index) ? (UIApplication.dark ? 0.5 : 0.2) : 1)
                        .frame(width: 16, height: 16)
                    Text(verbatim: session.archive[name: .board(index)])
                        .foregroundColor(hidden.contains(index) ?  .init(.tertiaryLabel) : .primary)
                        .font(.footnote)
                    Spacer()
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal)
        }
    }
}
