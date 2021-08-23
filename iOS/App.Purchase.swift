import SwiftUI

extension App {
    struct Purchase: View {
        @Binding var session: Session
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            VStack {
                Spacer()
                Image("full")
                    .foregroundColor(.primary)
                    .padding(.bottom)
                Text("Unable to create a new project")
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .center)
                    .padding(.horizontal)
                Text("""
You have reached your maximum capacity for projects.
Check purchases for more details.
""")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .center)
                    .padding(.horizontal)
                Spacer()
                Button {
                    session.modal.send(.store)
                } label: {
                    ZStack {
                        Capsule()
                            .fill(Color.accentColor)
                        Text("VIEW")
                            .foregroundColor(.white)
                            .font(.footnote)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 42)
                    }
                    .fixedSize()
                    .contentShape(Rectangle())
                }
                Button {
                    visible.wrappedValue.dismiss()
                } label: {
                    Text("CANCEL")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                        .frame(width: 150, height: 50)
                }
                Spacer()
                    .frame(height: 20)
            }
        }
    }
}
