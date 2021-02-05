import SwiftUI

extension Board {
    struct Menu: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        let board: Int
        let local: Namespace.ID
        @State private var settings = false
        @State private var add = false
        
        var body: some View {
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    if fold.count == session[board].count {
                        Control(image: "xmark") {
                            session.board.send(nil)
                        }
                        .matchedGeometryEffect(id: "close", in: local)
                    }
                    
                    Control(image: "slider.vertical.3") {
                        settings = true
                    }
                    .sheet(isPresented: $settings) {
                        Settings(session: $session, board: board)
                    }
                    
                    Control(image: "line.horizontal.3.decrease") {
                        
                    }
                    
                    Control(image: "plus") {
                        add = true
                    }
                    .sheet(isPresented: $add) {
                        Editor(session: $session, board: board, card: nil)
                            .padding(.vertical)
                    }

                    Control(image: "barometer") {
                        
                    }
                }
                .padding(.bottom)
                .padding(.leading, fold.count == session[board].count ? 0 : Frame.bar.width)
            }
        }
    }
}
