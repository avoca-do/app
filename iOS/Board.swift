import SwiftUI

struct Board: View {
    @Binding var session: Session
    
    var body: some View {
        HStack {
            GeometryReader {
                Color(.systemBackground)
                    .frame(width: $0.safeAreaInsets.leading + 50)
                    .edgesIgnoringSafeArea(.all)
            }
            Spacer()
        }
        if session.board != nil {
            GeometryReader { geo in
                VStack {
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
                    .background(Color.blue)
                    .edgesIgnoringSafeArea([.leading, .trailing])
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}
