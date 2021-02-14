import SwiftUI

extension Board {
    struct Bar: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        let global: Namespace.ID
        let local: Namespace.ID
        
        var body: some View {
            if fold.count < session.archive.count(session.path.board) {
                GeometryReader { geo in
                    HStack {
                        Rectangle()
                            .fill(Color.accentColor)
                            .frame(width: Metrics.bar.width + geo.safeAreaInsets.leading)
                            .matchedGeometryEffect(id: "bar\(session.path._board)", in: global)
                            .matchedGeometryEffect(id: "close", in: local)
                        Spacer()
                    }
                    .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}
