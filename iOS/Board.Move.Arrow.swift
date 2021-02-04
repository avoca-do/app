import SwiftUI

extension Board.Move {
    struct Arrow: View {
        let active: Bool
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack{
                    Circle()
                        .fill(Color.accentColor)
                    Image(systemName: image)
                        .font(Font.title3.bold())
                        .foregroundColor(.black)
                        .padding()
                }
                .fixedSize()
                .contentShape(Rectangle())
            }
            .opacity(active ? 1 : 0.2)
            .allowsHitTesting(active)
            .padding()
        }
    }
}
