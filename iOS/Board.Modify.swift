import SwiftUI

extension Board {
    struct Modify: View {
        @Binding var session: Session
        let board: Int
        @State private var column: Edit?
        
        var body: some View {
            ScrollView {
                Title(session: $session, title: "Columns")
                    .sheet(item: $column) {
                        Column(session: $session, board: board, column: $0.id)
                    }
                ForEach(0 ..< session[board].count, id: \.self) { index in
                    Button {
                        column = .init(id: index)
                    } label: {
                        ZStack {
                            Capsule()
                                .fill(Color.accentColor)
                            HStack {
                                Text(verbatim: session[board][index].title)
                                    .bold()
                                    .padding(.leading)
                                Spacer()
                                Text(NSNumber(value: session[board][index].count), formatter: session.decimal)
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
                Field(session: $session, mode: .newColumn(board))
                    .frame(height: 0)
                Tool(text: "New column", image: "plus") {
                    session.become.send(.newColumn(board))
                }
                .padding(.vertical)
            }
        }
    }
}

private struct Edit: Identifiable {
    let id: Int
}
