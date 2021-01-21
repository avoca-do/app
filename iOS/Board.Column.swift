import SwiftUI
import Kanban

extension Board {
    struct Column: View {
        @Binding var session: Session
        let column: Kanban.Board.Column
        
        var body: some View {
            if session.board != nil {
                ZStack {
                    if session.board!.columns.firstIndex(of: column)! % 2 != 0 {
                        Color(.tertiarySystemBackground)
                            .padding(.leading, 50)
                    }
                    VStack {
                        Spacer()
                            .frame(height: 10)
                        ForEach(column.cards, id: \.self) {
                            Card(session: $session, card: $0)
                        }
                        if column != session.board!.columns.last! {
                            Rectangle()
                                .fill(Color(.secondarySystemFill))
                                .frame(height: 1)
                        }
                    }
                    .padding(.leading, 50)
                    HStack {
                        Text(verbatim: column.name)
                            .rotationEffect(.radians(.pi / -2), anchor: .bottomLeading)
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .padding(.leading, 25)
                            .padding()
                            .offset(y: (.init(column.name.count) * 5) - 15)
                        Spacer()
                    }
                }
            }
        }
    }
}
