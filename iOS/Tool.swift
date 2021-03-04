import SwiftUI

struct Tool: View {
    let text: String
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: Metrics.corners)
                    .fill(Color.primary.opacity(0.05))
                HStack {
                    Text(text)
                        .font(.callout)
                        .padding(.leading)
                    Spacer()
                    Image(systemName: image)
                        .padding(.trailing)
                }
                .foregroundColor(.primary)
            }
            .frame(height: 50)
            .contentShape(Rectangle())
        }
        .padding(.horizontal, 30)
    }
}
