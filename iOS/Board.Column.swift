import SwiftUI
import UIKit

extension Board {
    struct Column: View {
        @Binding var session: Session
        let board: Int
        let column: Int
        
        var body: some View {
            ZStack {
                Color(column % 2 == 0 ? .secondarySystemBackground : .tertiarySystemBackground)
                    .padding(.leading, 50)
                VStack {
                    Spacer()
                        .frame(height: 10)
                    ForEach(0 ..< session[board][column].count, id: \.self) {
                        Card(session: $session, board: board, column: column, card: $0)
                        if $0 < session[board][column].count - 1 {
                            Rectangle()
                                .fill(Color(.quaternarySystemFill))
                                .frame(height: 1)
                        }
                    }
                    if column < session[board].count - 1 {
                        Rectangle()
                            .fill(Color(.secondarySystemFill))
                            .frame(height: 1)
                    }
                }
                .padding(.leading, 50)
                HStack {
                    Text(verbatim: session[board][column].title)
                        .rotationEffect(.radians(.pi / -2), anchor: .bottomLeading)
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .padding(.leading, 25)
                        .padding()
                        .offset(y: (.init(session[board][column].title.count) * 5) - 15)
                    Spacer()
                }
            }
        }
    }
}
