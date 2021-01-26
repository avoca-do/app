import SwiftUI
import Kanban

extension Board {
    struct Card: View {
        @Binding var session: Session
        let board: Int
        let column: Int
        let card: Int
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.accent)
                    .frame(minHeight: 2)
                    .frame(width: 2)
                Text(verbatim: session[board][column][card])
                    .font(.footnote)
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
        }
    }
}
