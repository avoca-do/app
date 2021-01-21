import SwiftUI

struct Board: View {
    @Binding var session: Session
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack {
                    Color(.systemBackground)
                        .frame(width: geo.safeAreaInsets.leading + 50)
                        .edgesIgnoringSafeArea([.leading, .top, .bottom])
                    Spacer()
                }
                VStack {
                    if session.board != nil {
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(session.board!.columns, id: \.self) {
                                    Column(session: $session, column: $0)
                                }
                            }
                        }
                        .edgesIgnoringSafeArea(.trailing)
                        VStack {
                            HStack {
                                Text(verbatim: session.board!.name)
                                    .font(Font.callout.bold())
                                    .padding([.leading, .top])
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            HStack {
                                Text("hello")
                            }
                        }
                        .frame(height: geo.safeAreaInsets.bottom + 70)
                        .background(Color.accent)
                        .edgesIgnoringSafeArea([.leading, .trailing])
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}
