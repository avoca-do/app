import SwiftUI

struct Board: View {
    @Binding var session: Session
    let board: Int
    let global: Namespace.ID
    @State private var fold = Set<Int>()
    @Namespace private var local
    
    var body: some View {
        if fold.count < session[board].count {
            GeometryReader { geo in
                HStack {
                    Rectangle()
                        .fill(Color.accentColor)
                        .frame(width: Frame.bar.width + geo.safeAreaInsets.leading)
                        .matchedGeometryEffect(id: "bar\(board)", in: global)
                        .matchedGeometryEffect(id: "close", in: local)
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    if fold.count < session[board].count {
                        Button {
                            session.board.send(nil)
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .font(.callout)
                                .frame(width: Frame.bar.width, height: 50)
                        }
                        .contentShape(Rectangle())
                    }
                    Text(verbatim: session[board].name)
                        .font(Font.title3.bold())
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    Spacer()
                }
                .matchedGeometryEffect(id: "text\(board)", in: global)
                ForEach(0 ..< session[board].count, id: \.self) {
                    Column(session: $session, fold: $fold, board: board, column: $0)
                }
            }
        }
        VStack {
            Spacer()
            HStack {
                if fold.count == session[board].count {
                    Control(image: "xmark") {
                        session.board.send(nil)
                    }
                    .matchedGeometryEffect(id: "close", in: local)
                }
                Control(image: "line.horizontal.3.decrease") {
                    
                }
                Control(image: "plus") {
                    
                }
                Control(image: "slider.vertical.3") {
                    
                }
            }
            .padding(.leading, fold.count == session[board].count ? 0 : Frame.bar.width)
        }
    }
}
