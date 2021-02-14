import SwiftUI
import Kanban

extension Board {
    struct Card: View {
        @Binding var session: Session
        let path: Kanban.Path
        @State private var selected = false
        
        var body: some View {
            Button {
                selected = true
                session.path = path
            } label: {
                ZStack {
                    Rectangle()
                        .fill(Color.accentColor.opacity(selected ? 0.5 : 0))
                    HStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.accentColor.opacity(0.8))
                            .frame(minHeight: 6)
                            .frame(width: Metrics.indicator.hidden + Metrics.indicator.visible)
                        Text(verbatim: session.archive[content: path])
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                        Spacer()
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical)
                }
                .contentShape(Rectangle())
            }
            .onChange(of: session.path) { [old = session.path] in
                guard old == path, $0 != path else { return }
                selected = false
            }
        }
    }
}
