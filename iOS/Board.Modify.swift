import SwiftUI

extension Board {
    struct Modify: View {
        @Binding var session: Session
        let board: Int
        
        var body: some View {
            ScrollView {
                Title(session: $session, title: "Columns")
                ForEach(0 ..< session[board].count, id: \.self) { column in
                    Button {
                        
                    } label: {
                        ZStack {
                            Capsule()
                                .fill(Color.accentColor)
                            HStack {
                                Text(verbatim: session[board][column].title)
                                    .bold()
                                    .padding(.leading)
                                Spacer()
                                Text(NSNumber(value: session[board][column].count), formatter: session.decimal)
                                    .bold()
                                    .padding(.trailing)
                            }
                            .foregroundColor(.black)
                            .padding()
                        }
                        .contentShape(Rectangle())
                    }
                    .padding(.horizontal)
                }
                Tool(text: "New column", image: "plus") {
                    
                }
                .padding(.vertical)
            }
        }
    }
}
