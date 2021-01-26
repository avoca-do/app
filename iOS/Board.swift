import SwiftUI

struct Board: View {
    @Binding var session: Session
    let board: Int
    
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
                            .foregroundColor(.white)
                            .frame(width: 60, height: 50)
                    }
                    .contentShape(Rectangle())
                    .padding(.top, geo.safeAreaInsets.top)
                }
                .foregroundColor(.white)
                .background(Color.main)
                .edgesIgnoringSafeArea([.leading, .trailing])
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(0 ..< session[board].count, id: \.self) {
                            Column(session: $session, board: board, column: $0)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.trailing)
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                        .padding()
                        .padding(.bottom, geo.safeAreaInsets.bottom)
                    Spacer()
                }
                .foregroundColor(.white)
                .background(Color.main)
                .edgesIgnoringSafeArea([.leading, .trailing])
            }
            .edgesIgnoringSafeArea(.vertical)
        }
    }
}
