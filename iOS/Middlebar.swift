import SwiftUI

struct Middlebar: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
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
            VStack {
                Spacer()
                if !session.typing {
                    Button {
                        
                    } label: { }.buttonStyle(Neumorphic.Style(image: "plus"))
                    .padding([.trailing, .bottom], 20)
                    
//                    Neumorphic(image: "plus", action: add)
//                        .actionSheet(isPresented: $alert) {
//                            .init(title: .init("You have reached your maximum capacity for projects"),
//                                         message: .init("Check Capacity for more details"),
//                                         buttons: [
//                                             .default(.init("Capacity")) {
//                                                session.purchases.open.send()
//                                             },
//                                             .cancel()])
//                        }
                }
            }
            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .trailing)
        }
    }
}
