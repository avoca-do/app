import SwiftUI

struct Home: View {
    @Binding var session: Session
    let global: Namespace.ID
    @State private var capacity = false
    @State private var settings = false
    
    var body: some View {
        Color.background
            .edgesIgnoringSafeArea(.all)
        Field(session: $session, mode: .newBoard)
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
                    capacity = true
                }
                .sheet(isPresented: $capacity) {
                    Capacity(session: $session)
                }
                
                Neumorphic(image: "slider.horizontal.3") {
                    settings = true
                }
                .sheet(isPresented: $settings) {
                    Settings(session: $session)
                }
                
                if !session.typing {
                    Neumorphic(image: "plus") {
                        session.become.send(.newBoard)
                    }
                }
            }
            .padding(.bottom, 20)
        }
        .onReceive(session.purchases.open) {
            session.dismiss.send()
            capacity = true
        }
    }
}
