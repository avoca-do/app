import SwiftUI

extension Project {
    struct Title: View {
        @Binding var session: Session
        
        var body: some View {
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.35)) {
                        session.path = .archive
                    }
                } label: {
                    Image(systemName: "line.horizontal.3")
                        .foregroundColor(.secondary)
                }
                .frame(width: 50, height: 46)
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
