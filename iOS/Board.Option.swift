import SwiftUI

extension Board {
    struct Option: View {
        let text: String
        let image: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.secondarySystemBackground))
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
                .padding(.horizontal)
            }
        }
    }
}
