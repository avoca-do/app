import SwiftUI

struct Board: View {
    @Binding var session: Session
    let board: Int
    let animation: Namespace.ID
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                Rectangle()
                    .fill(Color.accentColor)
                    .frame(width: Frame.bar.width + geo.safeAreaInsets.leading)
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
        }
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button {
                        session.board.send(nil)
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.callout)
                            .frame(width: Frame.bar.width, height: 50)
                    }
                    .contentShape(Rectangle())
                    Text(verbatim: session[board].name)
                        .font(Font.title3.bold())
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    Spacer()
                }
                .matchedGeometryEffect(id: board, in: animation)
                ForEach(0 ..< session[board].count, id: \.self) {
                    Column(session: $session, board: board, column: $0)
                }
            }
        }
        VStack {
            Spacer()
            HStack {
                Control(image: "line.horizontal.3.decrease") {
                    
                }
                Control(image: "plus") {
                    
                }
                Control(image: "slider.vertical.3") {
                    
                }
            }
            .padding(.leading, Frame.bar.width)
        }
    }
}
