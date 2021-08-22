import SwiftUI

extension Project {
    struct Card: View {
        @Binding var session: Session
        let board: Int
        let column: Int
        let card: Int
        
        var body: some View {
            Button {
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.init(.secondarySystemBackground))
                    Text(verbatim: session.archive[board][column][card].content)
                        .font(.callout)
                        .kerning(1)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        .padding()
                }
                .padding(.horizontal)
            }
        }
    }
}
