import SwiftUI

extension Board {
    struct Content: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        let global: Namespace.ID
        
        var body: some View {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(verbatim: session.archive[name: session.path])
                        .bold()
                        .lineLimit(1)
                        .padding(.horizontal)
                        .matchedGeometryEffect(id: "text\(session.path._board)", in: global)
                    Spacer()
                    Button {
//                        session.selected = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                            .font(Font.callout.bold())
                            .frame(width: Metrics.bar.width, height: 56)
                    }
                    .contentShape(Rectangle())
                }
                Rectangle()
                    .fill(Color(.tertiarySystemBackground))
                    .frame(height: 1)
                    .matchedGeometryEffect(id: "bar\(session.path._board)", in: global)
                
//                ScrollView {
//                    VStack(spacing: 0) {
//                        ForEach(0 ..< session.archive.count(session.path.board), id: \.self) {
//                            Column(session: $session, fold: $fold, path: .column(session.path.board, $0))
//                            if $0 < session.archive.count(session.path.board) - 1 {
//                                HStack(spacing: 0) {
//                                    if fold.count < session.archive.count(session.path.board) {
//                                        Rectangle()
//                                            .fill(Color.black)
//                                            .frame(width: Metrics.bar.width, height: 0.5)
//                                    }
//                                    Rectangle()
//                                        .fill(Color.accentColor)
//                                        .frame(height: 2)
//                                }
//
//                            }
//                        }
//                        Spacer()
//                            .frame(height: 80)
//                    }
//                }
            }
        }
    }
}
