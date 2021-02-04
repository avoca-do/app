import SwiftUI
import Kanban

extension Board {
    struct Move: View {
        @Binding var session: Session
        @State var card: Position
        let board: Int
        @State private var offset = CGSize.zero
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            ZStack {
                Pattern()
                    .stroke(Color.primary.opacity(0.15), style: .init(lineWidth: 1, lineCap: .round, dash: [1, 4]))
            }
            .frame(width: 1000)
            .offset(offset)
        }
    }
}

private struct Pattern: Shape {
    func path(in rect: CGRect) -> Path {
        .init { path in
            path.move(to: .zero)
            (1 ..< 15).map { rect.maxX / .init(15) * .init($0) }.forEach {
                path.move(to: .init(x: $0, y: 0))
                path.addLine(to: .init(x: $0, y: rect.maxY))
            }
            (1 ..< 5).map { rect.maxY / .init(5) * .init($0) }.forEach {
                path.move(to: .init(x: 0, y: $0))
                path.addLine(to: .init(x: rect.maxX, y: $0))
            }
        }
    }
}
