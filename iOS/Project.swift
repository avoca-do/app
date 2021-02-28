import SwiftUI

struct Project: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Metrics.corners)
                .fill(Color(.secondarySystemBackground))
            ScrollView {
                HStack {
                    Text("Projects")
                        .bold()
                        .padding([.top, .leading])
                    Spacer()
                }
            }
        }
        .padding()
    }
}
