import SwiftUI

struct Board: View {
    @Binding var session: Session
    let board: Int
    let animation: Namespace.ID
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack {
                    Text(verbatim: session[board].name)
                        .lineLimit(1)
                        .font(Font.callout.bold())
                        .padding()
                        .padding(.top, geo.safeAreaInsets.top)
                    Spacer()
                    Button {
                        session.board.send(nil)
                    } label: {
                        Image(systemName: "xmark")
                            .font(.callout)
                            .frame(width: 60, height: 50)
                    }
                    .contentShape(Rectangle())
                    .padding(.top, geo.safeAreaInsets.top)
                }
                .foregroundColor(.black)
                .background(Color.accentColor)
                .colorScheme(.light)
                .matchedGeometryEffect(id: board, in: animation)
                .edgesIgnoringSafeArea([.leading, .trailing])
                ZStack {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(0 ..< session[board].count, id: \.self) {
                                Column(session: $session, board: board, column: $0)
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.trailing)
                    HStack {
                        Rectangle()
                            .fill(Color.accentColor)
                            .offset(x: 50)
                            .frame(width: 1)
                        Spacer()
                    }
                }
                .zIndex(-1)
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                        .padding()
                        .padding(.bottom, geo.safeAreaInsets.bottom)
                    Spacer()
                }
                .foregroundColor(.black)
                .background(Color.accentColor)
                .edgesIgnoringSafeArea([.leading, .trailing])
            }
            .edgesIgnoringSafeArea(.vertical)
        }
    }
}
