import SwiftUI

struct Project: View {
    @Binding var session: Session
    let board: Int
    @State private var current = 0
    
    var body: some View {
        ScrollView {
            Text(verbatim: session.archive[board].name)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding([.leading, .trailing, .top])
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
                    HStack {
                        ForEach(0 ..< session.archive[board].count, id: \.self) {
                            Column(session: $session, current: $current, board: board, index: $0)
                        }
                    }
                    .padding()
                }
                if session.archive[board][current].isEmpty {
                    Spacer()
                        .frame(height: 150)
                    Text("No cards in this column")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding()
                    if current == 0 {
                        Actioner(title: "Add card") {
                            session.modal.send(.write(.card(board)))
                        }
                    }
                } else {
                    ForEach(0 ..< session.archive[board][current].count, id: \.self) {
                        Card(session: $session, board: board, column: current, card: $0)
                    }
                }
            }
            Spacer()
                .frame(height: 20)
        }
        .navigationBarItems(
            trailing: HStack {
                Option(symbol: "slider.horizontal.3") {
                    session.modal.send(.edit(board))
                }
                Option(symbol: "waveform.path.ecg") {
                    
                }
                Option(symbol: "barometer") {
                    
                }
                Option(symbol: "plus") {
                    current = 0
                    if session.archive[board].isEmpty {
                        session.modal.send(.write(.column(board)))
                    } else {
                        session.modal.send(.write(.card(board)))
                    }
                }
            })
    }
}
