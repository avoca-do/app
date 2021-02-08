import SwiftUI

extension Board {
    struct Menu: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        let board: Int
        let local: Namespace.ID
        @State private var settings = false
        @State private var modify = false
        @State private var add = false
        @State private var progress = false
        
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
                        modify = true
                    }
                    .sheet(isPresented: $modify) {
                        Modify(session: $session, board: board)
                    }
                    
                    Control(image: "plus") {
                        add = true
                    }
                    .sheet(isPresented: $add) {
                        Editor(session: $session, board: board, card: nil)
                            .padding(.vertical)
                    }

                    Control(image: "barometer") {
                        progress = true
                    }
                    .sheet(isPresented: $progress) {
                        Progress(session: $session, board: board, progress: session[board].progress)
                    }
                }
                .padding(.bottom)
                .padding(.leading, fold.count == session[board].count ? 0 : Metrics.bar.width)
            }
            .onReceive(session.purchases.open) {
                session.dismiss.send()
                session.card.send(nil)
                session.board.send(nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    session.purchases.open.send()
                }
            }
        }
    }
}
