import SwiftUI
import Kanban

extension Middlebar {
    struct Item: View {
        @Binding var session: Session
        let path: Kanban.Path
        @State private var date = ""
        
        var body: some View {
            Button {
                UIApplication.shared.resign()
                withAnimation(.easeInOut(duration: 0.4)) {
                    session.path = .column(path, 0)
                    session.open = true
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: Metrics.corners)
                        .fill(Color.primary.opacity(0.04))
                    VStack(alignment: .leading) {
                        Text(verbatim: session.archive[name: path])
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(verbatim: date)
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding()
                }
                .contentShape(Rectangle())
            }
            .padding(.horizontal)
            .onAppear(perform: refresh)
            .onChange(of: session.archive.count(session.path)) { _ in
                refresh()
            }
        }
        
        private func refresh() {
            date = RelativeDateTimeFormatter().string(from: session.archive.date(path), to: .init())
        }
    }
}
