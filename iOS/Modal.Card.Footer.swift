import SwiftUI

extension Modal.Card {
    struct Footer: View {
        @Binding var session: Session
        
        var body: some View {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.black)
                }
                .frame(width: 64, height: 60)
                .contentShape(Rectangle())
                Button {
                    
                } label: {
                    Image(systemName: "text.cursor")
                        .foregroundColor(.black)
                }
                .frame(width: 64, height: 60)
                .contentShape(Rectangle())
            }
            .font(.title3)
        }
    }
}
