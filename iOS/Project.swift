import SwiftUI

struct Project: View {
    @Binding var session: Session
    
    var body: some View {
        VStack(spacing: 0) {
            Title(session: $session)
            GeometryReader { proxy in
                HStack {
                    ForEach(0 ..< session.archive.count(session.path.board), id: \.self) {
                        Column(session: $session, path: .column(session.path.board, $0))
                            .frame(width: proxy.size.width * Metrics.paging.width)
                            .padding($0 == 0 ? [.leading] : [])
                            .padding($0 < session.archive.count(session.path.board) - 1 ? [] : [.trailing])
                    }
                }
                .offset(x: proxy.size.width * Metrics.paging.width * .init(-session.path._column))
            }
            HStack {
                ForEach(0 ..< session.archive.count(session.path.board), id: \.self) { index in
                    ZStack {
                        Circle()
                            .fill(session.path._column == index ? Color.primary : .secondary)
                            .frame(width: 6, height: 6)
                    }
                    .frame(height: 30)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeIn(duration: 0.3)) {
                            session.path = .column(session.path.board, index)
                        }
                    }
                    .disabled(session.path._column == index)
                }
            }
            Options(session: $session)
        }
    }
}
