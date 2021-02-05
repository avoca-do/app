import SwiftUI

struct Home: View {
    @Binding var session: Session
    let global: Namespace.ID
    
    var body: some View {
        Color.background
            .edgesIgnoringSafeArea(.all)
        Field(session: $session, board: nil)
        if !session.isEmpty {
            ScrollView {
                ForEach(0 ..< session.count, id: \.self) {
                    Item(session: $session, board: $0, global: global)
                }
                Spacer()
                    .frame(height: 100)
            }
        }
        VStack {
            Spacer()
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
