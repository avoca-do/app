import SwiftUI
import Kanban

struct Project: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                
            }
        }
        .navigationBarTitle(board.name, displayMode: .large)
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
    
    private var board: Board {
        if case let .project(board) = session.section {
            return session.archive[board]
        }
        return .init()
    }
}
