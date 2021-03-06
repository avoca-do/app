import SwiftUI

extension Project {
    struct Paging: View {
        @Binding var session: Session
        
        var body: some View {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .frame(width: 65, height: 55)
                    .onTapGesture {
                        guard session.path._column > 0 else { return }
                        show(session.path._column - 1)
                    }
                ForEach(0 ..< session.archive.count(session.path.board), id: \.self) { index in
                    ZStack {
                        Circle()
                            .fill(session.path._column == index ? Color.primary : Color(.tertiaryLabel))
                            .frame(width: 6, height: 6)
                    }
                    .frame(width: 14, height: 60)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        show(index)
                    }
                    .disabled(session.path._column == index)
                }
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .frame(width: 65, height: 55)
                    .onTapGesture {
                        guard session.path._column < session.archive.count(session.path.board) - 1 else { return }
                        show(session.path._column + 1)
                    }
            }
        }
        
        private func show(_ index: Int) {
            withAnimation(.spring(blendDuration: 0.35)) {
                session.path = .column(session.path.board, index)
            }
        }
    }
}
