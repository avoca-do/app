import SwiftUI

struct Project: View {
    @Binding var session: Session
    
    var body: some View {
        VStack(spacing: 0) {
            Title(session: $session)
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    ForEach(0 ..< session.archive.count(session.path.board), id: \.self) {
                        Column(session: $session, path: .column(session.path.board, $0))
                            .frame(width: proxy.size.width * Metrics.paging.width)
                            .padding(.leading, $0 == 0 ? Metrics.paging.space : Metrics.paging.padding)
                            .padding(.trailing, $0 == session.archive.count(session.path.board) - 1 ? Metrics.paging.space : 0)
                    }
                }
                .offset(x: ((proxy.size.width * Metrics.paging.width) + Metrics.paging.padding) * .init(-session.path._column))
            }
            Paging(session: $session)
            Options(session: $session)
        }
    }
}
