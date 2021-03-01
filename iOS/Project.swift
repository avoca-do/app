import SwiftUI

struct Project: View {
    @Binding var session: Session
    
    var body: some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    session.path = .archive
                }
            } label: {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(.secondary)
            }
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
            Text(verbatim: session.archive[name: session.path])
                .bold()
                .lineLimit(1)
            Spacer()
        }
        .padding([.top, .leading])
        ZStack {
            RoundedRectangle(cornerRadius: Metrics.corners)
                .fill(Color(.secondarySystemBackground))
            ScrollView {
                
            }
        }
        .padding([.leading, .trailing, .bottom])
    }
}
