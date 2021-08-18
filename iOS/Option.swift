import SwiftUI

struct Option: View {
    let symbol: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.body)
                .foregroundColor(.primary)
                .frame(width: 42)
        }
    }
}
