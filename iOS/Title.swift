import SwiftUI
import Kanban

struct Title: View {
    @Binding var session: Session
    let title: String
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.border)
                .frame(height: 2)
                .padding(.top, 58)
            Text(title)
                .bold()
                .foregroundColor(.secondary)
                .lineLimit(1)
                .frame(maxWidth: 240)
            HStack {
                Spacer()
                Button {
                    UIApplication.shared.resign()
                    visible.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .frame(width: 60, height: 60)
                }
                .contentShape(Rectangle())
            }
        }
        .frame(height: 60)
        .onReceive(session.dismiss) {
            visible.wrappedValue.dismiss()
        }
    }
}
