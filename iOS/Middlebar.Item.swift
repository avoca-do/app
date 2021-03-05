import SwiftUI
import Kanban

extension Middlebar {
    struct Item: View {
        @Binding var session: Session
        let path: Kanban.Path
        
        var body: some View {
            Button {
                UIApplication.shared.resign()
                withAnimation(.spring(blendDuration: 0.4)) {
                    session.path = .column(path, 0)
                    session.open = true
                }
            } label: { }.buttonStyle(Style(name: session.archive[name: path],
                                           date: RelativeDateTimeFormatter().string(from: session.archive.date(path), to: .init())))
            .padding(.horizontal)
        }
    }
}
