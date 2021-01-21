import SwiftUI
import Kanban

extension Board {
    struct Card: View {
        @Binding var session: Session
        let card: Kanban.Board.Card
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.accent)
                    .frame(minHeight: 4)
                    .frame(width: 4)
                Text(verbatim: card.content)
                    .font(.footnote)
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
        }
    }
}
