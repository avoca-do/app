import SwiftUI

struct Home: View {
    @Binding var session: Session
    let animation: Namespace.ID
    
    var body: some View {
        Color.background
            .edgesIgnoringSafeArea(.all)
        ScrollView {
            ForEach(0 ..< session.archive.count, id: \.self) {
                Item(session: $session, board: $0)
                    .matchedGeometryEffect(id: $0, in: animation)
            }
            Spacer()
                .frame(height: 100)
        }
        VStack {
            Spacer()
            Field(session: $session)
                .frame(height: 0)
            HStack {
                Neumorphic(image: "square.stack") {
                    
                }
                Neumorphic(image: "slider.horizontal.3") {
                    
                }
                if !session.typing {
                    Neumorphic(image: "plus") {
                        session.become.send()
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
}
