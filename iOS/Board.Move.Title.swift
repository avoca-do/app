import SwiftUI
import Kanban

extension Board.Move {
    struct Title: View {
        @Binding var session: Session
        @Binding var card: Position!
        let board: Int
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            ZStack {
                Text("Move")
                    .bold()
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
            .padding(.top)
            .onReceive(session.dismiss) {
                visible.wrappedValue.dismiss()
            }
        }
    }
}
