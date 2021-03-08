import SwiftUI

struct Middlebar: View {
    @Binding var session: Session
    @State private var alert = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Projects")
                    .bold()
                    .padding(.leading)
                Spacer()
                Button {
                    if session.archive.available {
                        session.become.send(.new(.archive))
                    } else {
                        alert = true
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .frame(width: 45, height: 50)
                        .padding(.leading)
                        
                }
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
            ZStack {
                RoundedRectangle(cornerRadius: Metrics.corners)
                    .fill(Color(.secondarySystemBackground))
                if session.archive.isEmpty(.archive) {
                    Text("Tab +\nto start a project")
                        .foregroundColor(.secondary)
                        .padding([.top, .leading], 20)
                        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
                } else {
                    ScrollView {
                        Spacer()
                            .frame(height: 10)
                        ForEach(0 ..< session.archive.count(.archive), id: \.self) {
                            Item(session: $session, path: .board($0))
                        }
                        Spacer()
                            .frame(height: 20)
                    }
                    .padding(2)
                }
            }
            Field(session: $session, write: .new(.archive))
                .frame(height: 0)
        }
    }
}
