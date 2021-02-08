import SwiftUI

extension Board {
    struct Content: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        let board: Int
        let global: Namespace.ID
        
        var body: some View {
            ScrollView {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        if fold.count < session[board].count {
                            Button {
                                session.board.send(nil)
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                                    .font(Font.callout.bold())
                                    .frame(width: Metrics.bar.width, height: 65)
                            }
                            .contentShape(Rectangle())
                        }
                        Text(verbatim: session[board].name)
                            .font(Font.title2.bold())
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                            .padding(.leading, fold.count == session[board].count ? 0 : Metrics.indicator.visible)
                        Spacer()
                    }
                    .matchedGeometryEffect(id: "text\(board)", in: global)
                    ForEach(0 ..< session[board].count, id: \.self) {
                        Column(session: $session, fold: $fold, board: board, column: $0)
                        if $0 < session[board].count - 1 {
                            HStack(spacing: 0) {
                                if fold.count < session[board].count {
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(width: Metrics.bar.width, height: 0.5)
                                }
                                Rectangle()
                                    .fill(Color.accentColor)
                                    .frame(height: 2)
                            }
                            
                        }
                    }
                    Spacer()
                        .frame(height: 80)
                }
            }
        }
    }
}
