import SwiftUI

extension Board {
    struct Card: View {
        @Binding var session: Session
        let board: Int
        let column: Int
        let card: Int
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.accentColor.opacity(0.4))
                    .cornerRadius(3)
                    .frame(minHeight: 6)
                    .frame(width: Frame.indicator.hidden + Frame.indicator.visible)
                Text(verbatim: session[board][column, card])
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.footnote)
                    .padding(.horizontal)
                Spacer()
            }
            .padding(.vertical, 1)
        }
    }
}
