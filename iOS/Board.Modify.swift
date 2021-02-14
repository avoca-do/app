import SwiftUI
import Kanban

extension Board {
    struct Modify: View {
        @Binding var session: Session
        @State private var path: Kanban.Path?
        
        var body: some View {
            ScrollView {
                Title(session: $session, title: "Columns")
                    .sheet(item: $path) {
                        Column(session: $session, path: $0)
                    }
                ForEach(0 ..< session.archive.count(session.path.board), id: \.self) { index in
                    Button {
                        UIApplication.shared.resign()
                        path = .column(session.path.board, index)
                    } label: {
                        ZStack {
                            Capsule()
                                .fill(Color.accentColor)
                            HStack {
                                Text(verbatim: session.archive[title: .column(session.path.board, index)])
                                    .bold()
                                    .padding(.leading)
                                Spacer()
                                Text(NSNumber(value: session.archive.count(.column(session.path.board, index))), formatter: session.decimal)
                                    .bold()
                                    .padding(.trailing)
                            }
                            .foregroundColor(.black)
                            .padding()
                        }
                        .contentShape(Rectangle())
                    }
                    .padding(.horizontal)
                }
                Field(session: $session, write: .new(session.path.board))
                    .frame(height: 0)
                Tool(text: "New column", image: "plus") {
                    session.become.send(.new(session.path.board))
                }
                .padding(.vertical)
            }
        }
    }
}
