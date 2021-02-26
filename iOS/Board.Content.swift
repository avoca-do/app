import SwiftUI

extension Board {
    struct Content: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        let global: Namespace.ID
        
        var body: some View {
            ScrollView {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        if fold.count < session.archive.count(session.path.board) {
                            Button {
                                session.path = .archive
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                                    .font(Font.callout.bold())
                                    .frame(width: Metrics.bar.width, height: 65)
                            }
                            .contentShape(Rectangle())
                        }
                        Text(verbatim: session.archive[name: session.path])
                            .font(Font.title2.bold())
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                            .padding(.leading, fold.count == session.archive.count(session.path.board) ? 0 : Metrics.indicator.visible)
                        Spacer()
                    }
                    .matchedGeometryEffect(id: "text0", in: global)
                    ForEach(0 ..< session.archive.count(session.path.board), id: \.self) {
                        Column(session: $session, fold: $fold, path: .column(session.path.board, $0))
                        if $0 < session.archive.count(session.path.board) - 1 {
                            HStack(spacing: 0) {
                                if fold.count < session.archive.count(session.path.board) {
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
