import SwiftUI
import Kanban

struct Home: View {
    @Binding var session: Session
    let global: Namespace.ID
    @State private var capacity = false
    @State private var settings = false
    @State private var alert = false
    
    var body: some View {
        Color.background
            .edgesIgnoringSafeArea(.all)
        ScrollView {
            ForEach(0 ..< session.archive.count(.archive), id: \.self) {
                Item(session: $session, path: .board($0), global: global)
            }
            Spacer()
                .frame(height: 100)
        }
        Field(session: $session, write: .new(.archive))
            .frame(width: 0, height: 0)
        VStack {
            Spacer()
            HStack {
                Neumorphic(image: "square.stack") {
                    UIApplication.shared.resign()
                    capacity = true
                }
                .sheet(isPresented: $capacity) {
                    Capacity(session: $session)
                }
                
                Neumorphic(image: "slider.horizontal.3") {
                    UIApplication.shared.resign()
                    settings = true
                }
                .sheet(isPresented: $settings) {
                    Settings(session: $session)
                }
                
                if !session.typing {
                    Neumorphic(image: "plus", action: add)
                        .actionSheet(isPresented: $alert) {
                            .init(title: .init("You have reached your maximum capacity for projects"),
                                         message: .init("Check Capacity for more details"),
                                         buttons: [
                                             .default(.init("Capacity")) {
                                                session.purchases.open.send()
                                             },
                                             .cancel()])
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
    
    private func add() {
        if session.archive.available {
            session.become.send(.new(.archive))
        } else {
            alert = true
        }
    }
}
