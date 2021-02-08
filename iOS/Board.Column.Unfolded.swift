import SwiftUI

extension Board.Column {
    struct Unfolded: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        let board: Int
        let column: Int
        
        var body: some View {
            if session[board].count > column {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.accentColor.opacity(0.01))
                        .frame(width: Frame.bar.width - Frame.indicator.hidden)
                        .allowsHitTesting(true)
                        .onTapGesture {
                            fold.insert(column)
                        }
                    VStack(spacing: 0) {
                        if session[board][column].isEmpty {
                            HStack {
                                Spacer()
                                    .padding(.vertical)
                            }
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
                }
                HStack {
                    VStack {
                        Text(verbatim: session[board][column].title)
                            .bold()
                            .lineLimit(1)
                            .frame(maxWidth: Frame.column.height - 10)
                        Text(NSNumber(value: session[board][column].count), formatter: session.decimal)
                            .lineLimit(1)
                            .font(.footnote)
                            .frame(maxWidth: Frame.column.height - 10)
                    }
                    .frame(width: Frame.column.height)
                    .contentShape(Rectangle())
                    .foregroundColor(.black)
                    .rotationEffect(.radians(.pi / -2), anchor: .leading)
                    .padding(.leading, 20)
                    .padding()
                    .offset(y: Frame.column.height / 2)
                    Spacer()
                }
                .allowsHitTesting(false)
            }
        }
    }
}
