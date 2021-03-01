import SwiftUI
import Kanban

struct Column: View {
    @Binding var session: Session
    let path: Kanban.Path
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Metrics.corners)
                .fill(Color(.secondarySystemBackground))
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
                ScrollView {
                    ForEach(0 ..< session.archive.count(path), id: \.self) {
                        Card(session: $session, path: .card(path, $0))
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
