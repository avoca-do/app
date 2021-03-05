import SwiftUI
import Kanban

struct Column: View {
    @Binding var session: Session
    let path: Kanban.Path
    
    var body: some View {
        VStack {
            HStack {
                Text(verbatim: session.archive[title: path])
                    .kerning(1)
                    .bold()
                Spacer()
                Text(NSNumber(value: session.archive.count(path)), formatter: session.decimal)
                    .kerning(1)
                    .padding(.leading)
            }
            .foregroundColor(.secondary)
            .padding([.horizontal])
            ZStack {
                RoundedRectangle(cornerRadius: Metrics.corners)
                    .fill(Color(.secondarySystemBackground))
                    .onTapGesture {
                        withAnimation(.spring(blendDuration: 0.35)) {
                            session.path = path
                        }
                    }
                    .disabled(session.path.column == path)
                    .allowsHitTesting(session.path.column != path)
                ScrollView(session.path.column == path ? .vertical : []) {
                    Spacer()
                        .frame(height: 10)
                    ForEach(0 ..< session.archive.count(path), id: \.self) {
                        Card(session: $session, path: .card(path, $0))
                    }
                    Spacer()
                        .frame(height: 20)
                }
                .disabled(session.path.column != path)
                .allowsHitTesting(session.path.column == path)
            }
        }
        .opacity(session.path.column == path
                    ? 1
                    : UIApplication.dark
                        ? 0.4
                        : 0.2)
    }
}
