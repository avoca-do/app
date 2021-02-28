import SwiftUI

struct Project: View {
    @Binding var session: Session
    
    var body: some View {
        HStack {
            Text(verbatim: session.archive[name: session.path])
                .bold()
                .padding([.top, .leading])
            Spacer()
        }
        ZStack {
            RoundedRectangle(cornerRadius: Metrics.corners)
                .fill(Color(.secondarySystemBackground))
            ScrollView {
                
            }
        }
        .padding()
    }
}
