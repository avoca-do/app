import SwiftUI
import Kanban

extension Project {
    struct Columns: View {
        @Binding var session: Session
        @State private var path: Kanban.Path?
        
        var body: some View {
            VStack {
                Dismisser(session: $session)
                    .sheet(item: $path) {
                        Edit(session: $session, path: $0)
                    }
                Text("Columns")
                    .font(Font.title2.bold())
                    .padding()
                Spacer()
                    .frame(height: 40)
                ForEach(0 ..< session.archive.count(session.path.board), id: \.self) { index in
                    Button {
                        UIApplication.shared.resign()
                        path = .column(session.path.board, index)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: Metrics.corners)
                                .fill(Color.accentColor.opacity(Metrics.accent.low))
                            HStack {
                                Text(verbatim: session.archive[title: .column(session.path.board, index)])
                                    .kerning(1)
                                    .fontWeight(.medium)
                                Spacer()
                                Text(NSNumber(value: session.archive.count(.column(session.path.board, index))), formatter: session.decimal)
                                    .bold()
                            }
                            .foregroundColor(.primary)
                            .padding()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 30)
                }
                Tool(text: "New column", image: "plus") {
                    session.become.send(.new(session.path.board))
                }
                Field(session: $session, write: .new(session.path.board))
                    .frame(height: 0)
                Spacer()
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}
