import SwiftUI

struct Actioner: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                Text(title)
                    .foregroundColor(.white)
                    .frame(width: 180)
                    .padding(.vertical, 8)
            }
            .fixedSize()
        }
    }
}
