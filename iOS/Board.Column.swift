import SwiftUI

extension Board {
    struct Column: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        let board: Int
        let column: Int
        
        var body: some View {
            ZStack {
                if column % 2 != 0 {
                    Color.background
                        .padding(.leading, fold.count == session[board].count ? 0 : Metrics.bar.width)
                }
                if fold.contains(column) {
                    Folded(session: $session, fold: $fold, board: board, column: column)
                } else {
                    Unfolded(session: $session, fold: $fold, board: board, column: column)
                }
            }
        }
    }
}
