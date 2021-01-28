import SwiftUI

struct Neumorphic: View {
    let image: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color.clear)
                .frame(width: 80, height: 80)
        }
        .buttonStyle(Style(image: image))
    }
}
