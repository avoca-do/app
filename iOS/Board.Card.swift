import SwiftUI

extension Board {
    struct Card: View {
        @Binding var session: Session
        let board: Int
        let column: Int
        let card: Int
        
        var body: some View {
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.accentColor.opacity(0.4))
                    .frame(minHeight: 6)
                    .frame(width: Frame.indicator.hidden + Frame.indicator.visible)
                Text(verbatim: session[board][column, card])
                    .font(.footnote)
                    .padding(.horizontal)
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, 1)
        }
    }
}
