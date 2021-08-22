import SwiftUI

struct Project: View {
    @Binding var session: Session
    let board: Int
    @State private var current = 0
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                Text(verbatim: session.archive[board].name)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    .padding([.leading, .trailing, .top])
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0 ..< session.archive[board].count, id: \.self) {
                            Column(session: $session, current: $current, board: board, index: $0)
                        }
                    }
                    .padding()
                }
                ForEach(0 ..< session.archive[board][current].count, id: \.self) {
                    Card(session: $session, board: board, column: current, card: $0)
                }
                Spacer()
                    .frame(height: 20)
            }
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
                    
                }
            })
    }
}
