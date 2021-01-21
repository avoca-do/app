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
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(session.board!.columns, id: \.self) {
                        Column(session: $session, column: $0)
                    }
                    Spacer()
                        .frame(height: 90)
                }
            }
            
            GeometryReader { geo in
                VStack {
                    Spacer()
                    Color.blue
                        .frame(height: geo.safeAreaInsets.bottom + 70)
                        
                }
                .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                Spacer()
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
        }
    }
}
