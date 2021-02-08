import SwiftUI
import Kanban

struct Title: View {
    @Binding var session: Session
    let title: String
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        ZStack {
            Text(title)
                .bold()
                .lineLimit(1)
                .frame(maxWidth: 240)
            HStack {
                Spacer()
                Button {
                    visible.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .frame(width: 60, height: 50)
                }
                .contentShape(Rectangle())
            }
        }
        .padding(.vertical)
        .onReceive(session.dismiss) {
            visible.wrappedValue.dismiss()
        }
    }
}
