import SwiftUI

extension Project {
    struct Title: View {
        @Binding var session: Session
        
        var body: some View {
            HStack(spacing: 0) {
                Button {
                    withAnimation(.spring(blendDuration: 0.35)) {
                        session.path = .column(session.path.board, 0)
                        session.open = false
                    }
                } label: {
                    Image(systemName: "line.horizontal.3")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .frame(width: 60, height: 60)
                .contentShape(Rectangle())
                Text(verbatim: session.archive[name: session.path])
                    .bold()
                    .lineLimit(1)
                Spacer()
            }
            .padding(.leading)
        }
    }
}
