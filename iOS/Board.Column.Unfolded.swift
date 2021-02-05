import SwiftUI

extension Board.Column {
    struct Unfolded: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        let board: Int
        let column: Int
        
        var body: some View {
            if session[board].count > column {
                VStack(spacing: 0) {
                    if session[board][column].isEmpty {
                        Spacer()
                            .frame(height: Frame.column.height)
                    } else {
                        ForEach(0 ..< session[board][column].count, id: \.self) {
                            Board.Card(session: $session, board: board, column: column, card: $0)
                            if $0 < session[board][column].count - 1 {
                                Rectangle()
                                    .fill(Color.accentColor.opacity(0.5))
                                    .frame(height: 1)
                                    .padding(.leading, Frame.indicator.hidden)
                            }
                        }
                    }
                }
                .padding(.leading, Frame.bar.width - Frame.indicator.hidden)
                HStack {
                    VStack {
                        Text(verbatim: session[board][column].title)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .font(Font.body.bold())
                            .frame(maxWidth: Frame.column.height - 4)
                        Text(NSNumber(value: session[board][column].count), formatter: session.decimal)
                            .lineLimit(1)
                            .font(.footnote)
                            .frame(maxWidth: Frame.column.height - 4)
                    }
                    .frame(width: Frame.column.height)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        fold.insert(column)
                    }
                    .foregroundColor(.black)
                    .rotationEffect(.radians(.pi / -2), anchor: .leading)
                    .padding(.leading, 20)
                    .padding()
                    .offset(y: Frame.column.height / 2)
                    Spacer()
                }
            }
        }
    }
}
