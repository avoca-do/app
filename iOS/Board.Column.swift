import SwiftUI
import UIKit

extension Board {
    struct Column: View {
        @Binding var session: Session
        let board: Int
        let column: Int
        
        var body: some View {
            ZStack {
                if column % 2 != 0 {
                    Color.background
                        .padding(.leading, Frame.Bar.width)
                }
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
                    Spacer()
                    if column < session[board].count - 1 {
                        Rectangle()
                            .fill(Color(.secondarySystemFill))
                            .frame(height: 1)
                    }
                }
                .frame(minHeight: 160)
                .padding(.leading, Frame.Bar.width)
                HStack {
                    VStack {
                        Text(verbatim: session[board][column].title)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .font(Font.body.bold())
                            .frame(maxWidth: 140)
                        Text(verbatim: "1,011")
                            .lineLimit(1)
                            .font(.caption)
                            .frame(maxWidth: 140)
                    }
                    .frame(width: 160)
                    .foregroundColor(.black)
                    .rotationEffect(.radians(.pi / -2), anchor: .leading)
                    .padding(.leading, 20)
                    .padding()
                    .offset(y: 80)
                    Spacer()
                }
            }
        }
    }
}
