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
        Field(session: $session, mode: .newBoard)
        if session.isEmpty {
            VStack {
                Spacer()
                Image("logo")
                    .offset(y: -40)
                Text(verbatim: "Avocado")
                    .font(Font.largeTitle.bold())
                    .offset(y: -70)
                if !session.typing {
                    Button(action: add) {
                        ZStack {
                            Capsule()
                                .fill(Color.accentColor)
                            Text("Get Started")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                                .padding(.horizontal)
                        }
                        .fixedSize()
                        .contentShape(Rectangle())
                    }
                    .offset(y: -50)
                    .padding(.bottom, 40)
                }
                Spacer()
            }
        } else {
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
        if Defaults.capacity > session.count {
            session.become.send(.newBoard)
        } else {
            alert = true
        }
    }
}
