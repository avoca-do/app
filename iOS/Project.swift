import SwiftUI

struct Project: View {
    @Binding var session: Session
    let board: Int
    @State private var current = 0
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0 ..< session.archive[board].count, id: \.self) {
                            Column(session: $session, current: $current, board: board, index: $0)
                        }
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .navigationBarTitle(session.archive[board].name, displayMode: .large)
        .navigationBarItems(
            trailing: HStack {
                Option(symbol: "slider.horizontal.3") {
                    
                }
                Option(symbol: "waveform.path.ecg") {
                    
                }
                Option(symbol: "barometer") {
                    
                }
                Option(symbol: "plus.square") {
                    
                }
            })
    }
}
