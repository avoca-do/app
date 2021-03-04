import SwiftUI

struct Switch: View {
    let text: LocalizedStringKey
    @Binding var value: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Metrics.corners)
                .fill(Color.primary.opacity(0.05))
            Toggle(text, isOn: $value)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .font(.footnote)
                .padding(.horizontal)
        }
        .frame(height: 50)
        .padding(.horizontal, 30)
    }
}
