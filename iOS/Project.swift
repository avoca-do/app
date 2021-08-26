import SwiftUI

struct Project: View {
    @Binding var session: Session
    let board: Int
    
    var body: some View {
        ScrollView {
            if session.archive[board].isEmpty {
                Spacer()
                    .frame(height: 150)
                Text("No columns in this project")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .padding()
                Actioner(title: "Add column") {
                    session.modal.send(.write(.column(board)))
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< session.archive[board].count, id: \.self) {
                            Column(session: $session, board: board, index: $0)
                        }
                    }
                    .padding()
                }
                .padding(.vertical)
                if session.archive[board][session.column].isEmpty {
                    Spacer()
                        .frame(height: 150)
                    Text(session.archive[board].total == 0 ? "No cards in this project" : "No cards in this column")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding()
                    if session.column == 0 {
                        Actioner(title: "Add card") {
                            session.modal.send(.write(.card(board)))
                        }
                    }
                } else {
                    ForEach(0 ..< session.archive[board][session.column].count, id: \.self) {
                        Card(session: $session, path: .card(.column(.board(board), session.column), $0))
                    }
                }
            }
            Spacer()
                .frame(height: 20)
        }
        .navigationBarTitle(session.archive[board].name, displayMode: .large)
        .navigationBarItems(
            trailing: HStack {
                Option(symbol: "slider.horizontal.3") {
                    session.modal.send(.edit(board))
                }
                Option(symbol: "waveform.path.ecg") {
                    session.modal.send(.wave(board))
                }
                Option(symbol: "barometer") {
                    session.modal.send(.stats(board))
                }
                Option(symbol: "plus") {
                    session.column = 0
                    if session.archive[board].isEmpty {
                        session.modal.send(.write(.column(board)))
                    } else {
                        session.modal.send(.write(.card(board)))
                    }
                }
            })
    }
}
