import SwiftUI

struct Home: View {
    @Binding var session: Session
    let animation: Namespace.ID
    
    var body: some View {
        ZStack {
            Color.background
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                ForEach(0 ..< session.archive.count, id: \.self) {
                    Item(session: $session, board: $0)
                        .matchedGeometryEffect(id: $0, in: animation)
                }
            }
            VStack {
                Spacer()
                Field(session: $session)
                    .frame(height: 0)
                if !session.typing {
                    HStack {
                        Control.Circle(state: .ready, image: "square.stack") {
                            
                        }
                        Control.Circle(state: .ready, image: "slider.horizontal.3") {
                        
                        }
                        Control.Circle(state: .ready, image: "plus") {
                            session.become.send()
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
