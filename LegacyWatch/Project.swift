import SwiftUI

struct Project: View {
    @Binding var session: Session
    
    var body: some View {
        ScrollView {
            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    session.path = .archive
                }
            } label: {
                HStack {
                    Image(systemName: "line.horizontal.3")
                        .font(.title3)
                        .frame(width: 40, height: 35)
                    Text(verbatim: session.archive[name: session.path])
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.top, 25)
            }
            .contentShape(Rectangle())
            .buttonStyle(PlainButtonStyle())
            ForEach(0 ..< session.archive.count(session.path.board), id: \.self) {
                Spacer()
                    .frame(height: 10)
                Column(session: $session, path: .column(session.path.board, $0))
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}
