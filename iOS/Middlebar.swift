import SwiftUI

struct Middlebar: View {
    @Binding var session: Session
    @State private var alert = false
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Projects")
                    .bold()
                    .padding([.top, .leading])
                Spacer()
            }
            if session.archive.isEmpty(.archive) {
                HStack(alignment: .top) {
                    Text("Tab +\nto start a project")
                        .foregroundColor(.init(UIColor.tertiaryLabel))
                        .padding([.top, .leading])
                    Spacer()
                }
            } else {
                ForEach(0 ..< session.archive.count(.archive), id: \.self) {
                    Item(session: $session, path: .board($0))
                }
                Spacer()
                    .frame(height: 100)
            }
        }
        VStack(alignment: .trailing) {
            Spacer()
            Field(session: $session, write: .new(.archive))
                .frame(height: 0)
            if !session.typing {
                Button {
                    if session.archive.available {
                        session.become.send(.new(.archive))
                    } else {
                        alert = true
                    }
                } label: { }.buttonStyle(Neumorphic(image: "plus"))
                .padding([.trailing, .bottom], 20)
                .actionSheet(isPresented: $alert) {
                    .init(title: .init("You have reached your capacity for projects"),
                                 message: .init("Check Capacity for more details"),
                                 buttons: [
                                     .default(.init("Capacity")) {
                                        session.purchases.open.send()
                                     },
                                     .cancel()])
                }
            }
        }
        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
    }
}
