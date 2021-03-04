import SwiftUI
import Kanban

struct Dismisser: View {
    @Binding var session: Session
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
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
        .frame(height: 60)
        .onReceive(session.dismiss) {
            visible.wrappedValue.dismiss()
        }
    }
}
