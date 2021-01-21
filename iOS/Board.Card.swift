import SwiftUI
import Kanban

extension Board {
    struct Card: View {
        @Binding var session: Session
        let card: Kanban.Board.Card
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.accent)
                    .frame(minHeight: 2)
                    .frame(width: 2)
                Text(verbatim: card.content)
                    .font(.footnote)
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
        }
    }
}
