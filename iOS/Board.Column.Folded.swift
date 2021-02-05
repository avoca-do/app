import SwiftUI

extension Board.Column {
    struct Folded: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        let board: Int
        let column: Int
        
        var body: some View {
            if session[board].count > column {
                HStack {
                    Text(verbatim: session[board][column].title)
                        .lineLimit(1)
                        .font(Font.body.bold())
                    Text(NSNumber(value: session[board][column].count), formatter: session.decimal)
                        .font(.footnote)
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
            }
        }
    }
}
