import SwiftUI
import Kanban

struct Column: View {
    @Binding var session: Session
    let path: Kanban.Path
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Metrics.corners)
                .fill(Color(.secondarySystemBackground))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        session.path = path
                    }
                }
                .disabled(session.path.column == path)
                .allowsHitTesting(session.path.column != path)
            VStack(spacing: 0) {
                HStack {
                    Text(verbatim: session.archive[title: path])
                        .bold()
                    Spacer()
                    Text(NSNumber(value: session.archive.count(path)), formatter: session.decimal)
                        .bold()
                }
                .padding()
                Rectangle()
                    .fill(Color(white: 0, opacity: 1))
                    .frame(height: 1)
                ScrollView(session.path.column == path ? .vertical : []) {
                    ForEach(0 ..< session.archive.count(path), id: \.self) {
                        Card(session: $session, path: .card(path, $0))
                    }
                }
            }
            .disabled(session.path.column != path)
            .allowsHitTesting(session.path.column == path)
        }
//        .opacity(session.path.column == path ? 1 : 0.5)
    }
}
