import SwiftUI

extension Board {
    struct Control: View {
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 64, height: 64)
                    Circle()
                        .fill(Color(.systemBackground))
                        .frame(width: 42, height: 42)
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 40, height: 40)
                    Image(systemName: image)
                        .foregroundColor(.black)
                }
            }
        }
    }
}
