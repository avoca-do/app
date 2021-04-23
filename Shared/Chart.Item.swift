import SwiftUI

extension Chart {
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
                        .fill(hidden.contains(index) ? Color.secondary.opacity(0.5) : Color.index(index))
                        .opacity(hidden.contains(index) ? 0.3 : 1)
                        .frame(width: Metrics.chart.circle, height: Metrics.chart.circle)
                    Text(verbatim: session.archive[name: .board(index)])
                        .foregroundColor(hidden.contains(index) ?  Color.secondary.opacity(0.5) : .primary)
                        .font(.footnote)
                    Spacer()
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal)
        }
    }
}
