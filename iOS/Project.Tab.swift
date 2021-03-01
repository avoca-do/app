import SwiftUI
import Kanban

extension Project {
    struct Tab: View {
        @Binding var session: Session
        let path: Kanban.Path
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: Metrics.corners)
                    .fill(Color(.secondarySystemBackground))
                VStack {
                    HStack {
                        Text(verbatim: session.archive[title: path])
                            .font(Font.body.bold())
                        Spacer()
                        Text(NSNumber(value: session.archive.count(path)), formatter: session.decimal)
                            .foregroundColor(.secondary)
                    }
                    .padding([.top, .horizontal])
                    ScrollView {
                        
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
