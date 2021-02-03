import SwiftUI
import UIKit

extension Board {
    struct Column: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        @Binding var formatter: NumberFormatter
        let board: Int
        let column: Int
        
        var body: some View {
            ZStack {
                if column % 2 != 0 {
                    Color.background
                        .padding(.leading, fold.count == session[board].count ? 0 : Frame.bar.width)
                }
                if !fold.contains(column) {
                    VStack {
                        if session[board][column].isEmpty {
                            Spacer()
                                .frame(height: Frame.column.height)
                        } else {
                            Spacer()
                                .frame(height: 10)
                            ForEach(0 ..< session[board][column].count, id: \.self) {
                                Card(session: $session, board: board, column: column, card: $0)
                                if $0 < session[board][column].count - 1 {
                                    Rectangle()
                                        .fill(Color(.tertiarySystemBackground))
                                        .frame(height: 1)
                                        .padding(.leading, Frame.indicator.hidden)
                                }
                            }
                            Spacer()
                        }
                        if column < session[board].count - 1 {
                            Rectangle()
                                .fill(Color(.secondarySystemFill))
                                .frame(height: 1)
                                .padding(.leading, Frame.indicator.hidden)
                        }
                    }
                    .padding(.leading, Frame.bar.width - Frame.indicator.hidden)
                }
                if fold.contains(column) {
                    HStack {
                        Text(verbatim: session[board][column].title)
                            .lineLimit(1)
                            .font(Font.body.bold())
                        Text(NSNumber(value: session[board][column].count), formatter: formatter)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "plus")
                            .font(.footnote)
                    }
                    .padding()
                    .padding(.vertical, 3)
                    .padding(.leading, fold.count == session[board].count ? 0 : Frame.bar.width + Frame.indicator.visible)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        fold.remove(column)
                    }
                } else {
                    HStack {
                        VStack {
                            Text(verbatim: session[board][column].title)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .font(Font.body.bold())
                                .frame(maxWidth: 140)
                            Text(NSNumber(value: session[board][column].count), formatter: formatter)
                                .lineLimit(1)
                                .font(.caption)
                                .frame(maxWidth: Frame.column.height - 20)
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
}
