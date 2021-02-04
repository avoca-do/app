import SwiftUI
import Kanban

extension Board.Move {
    struct Title: View {
        @Binding var session: Session
        @Binding var card: Position
        let board: Int
        @Environment(\.presentationMode) private var visible
        
        var body: some View {
            ZStack {
                Text("Move")
                    .bold()
                HStack {
                    Button {
                        visible.wrappedValue.dismiss()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.accentColor)
                            Text("Save")
                                .font(Font.callout.bold())
                                .foregroundColor(.black)
                                .padding(.horizontal)
                                .padding(.vertical, 6)
                        }
                        .fixedSize()
                    }
                    .contentShape(Rectangle())
                    .padding()
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
        }
    }
}
