import SwiftUI

extension Project.Card.Edit {
    struct Option: View {
        let icon: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Image(systemName: icon)
                    .font(.title)
                    .frame(width: 48, height: 60)
                    .contentShape(Rectangle())
            }
        }
    }
}
