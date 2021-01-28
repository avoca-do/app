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
                        .padding(.bottom)
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 44, height: 44)
                    Image(systemName: image)
                        .font(Font.title2)
                        .foregroundColor(.black)
                }
            }
        }
    }
}
