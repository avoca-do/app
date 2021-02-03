import SwiftUI

extension Board {
    struct Menu: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        let board: Int
        let local: Namespace.ID
        @State private var add = false
        
        var body: some View {
            VStack {
                Spacer()
                HStack {
                    if fold.count == session[board].count {
                        Control(image: "xmark") {
                            session.board.send(nil)
                        }
                        .matchedGeometryEffect(id: "close", in: local)
                    }
                    Control(image: "line.horizontal.3.decrease") {
                        
                    }
                    Control(image: "plus") {
                        add = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            session.become.send()
                        }
                    }
                    .sheet(isPresented: $add) {
                        Editor(session: $session, board: board)
                            .padding(.vertical)
                    }
                    Control(image: "slider.vertical.3") {
                        
                    }
                }
                .padding(.leading, fold.count == session[board].count ? 0 : Frame.bar.width)
            }
        }
    }
}
