import SwiftUI
import Kanban

extension Project {
    struct Column: View {
        @Binding var session: Session
        let path: Kanban.Path
        
        var body: some View {
            Group {
                Text(verbatim: session.archive[title: path])
                    .kerning(1)
                    .bold() +
                Text(verbatim: " ") +
                Text(NSNumber(value: session.archive.count(path)), formatter: session.decimal)
                    .kerning(1)
            }
            .foregroundColor(.accentColor)
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            Rectangle()
                .fill(Color.secondary)
                .frame(height: 1)
            ForEach(0 ..< session.archive.count(path), id: \.self) {
                Card(session: $session, path: .card(path, $0))
            }
            Rectangle()
                .fill(Color.secondary)
                .frame(height: 1)
        }
    }
}
