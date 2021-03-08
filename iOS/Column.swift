import SwiftUI
import Kanban

struct Column: View {
    @Binding var session: Session
    let path: Kanban.Path
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                Text(verbatim: session.archive[title: path])
                    .kerning(1)
                    .bold() +
                Text(verbatim: " ") +
                Text(NSNumber(value: session.archive.count(path)), formatter: session.decimal)
                    .kerning(1)
                    .font(.callout)
            }
            .foregroundColor(.secondary)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            .padding(.horizontal)
            Rectangle()
                .fill(Color(.tertiaryLabel))
                .frame(height: 1)
                .padding([.horizontal, .top])
            ScrollView(session.path.column == path ? .vertical : []) {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 20)
                    ForEach(0 ..< session.archive.count(path), id: \.self) {
                        Card(session: $session, path: .card(path, $0))
                    }
                    Spacer()
                        .frame(height: 30)
                }
            }
            .disabled(session.path.column != path)
            Rectangle()
                .fill(Color(.tertiaryLabel))
                .frame(height: 1)
                .padding(.horizontal)
        }
        .onTapGesture {
            guard session.path.column != path else { return }
            withAnimation(.spring(blendDuration: 0.35)) {
                session.path = path
            }
        }
        .opacity(session.path.column == path
                    ? 1
                    : UIApplication.dark
                        ? 0.35
                        : 0.15)
    }
}
