import SwiftUI

struct Middlebar: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemBackground))
            VStack {
                HStack {
                    Text("Projects")
                        .bold()
                        .padding()
                    Spacer()
                }
                Spacer()
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
