import SwiftUI

extension Board {
    struct Bar: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        let board: Int
        let global: Namespace.ID
        let local: Namespace.ID
        
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
        }
    }
}
