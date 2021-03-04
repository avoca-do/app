import SwiftUI

extension Modal {
    struct Card: View {
        @Binding var session: Session
        @State private var edit = false
        let dismiss: () -> Void
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: Metrics.corners)
                    .fill(Color.accentColor)
                VStack {
                    ZStack {
                        Horizontal(session: $session)
                        Vertical(session: $session)
                    }
                    .frame(height: 60)
                    Text(verbatim: session.archive[content: session.path])
                        .kerning(1)
                        .foregroundColor(Color.black)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            edit = true
                        }
                        .frame(height: 140, alignment: .top)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        .padding(.horizontal)
                    Footer(session: $session, edit: $edit, dismiss: dismiss)
                    Spacer()
                }
            }
            .frame(height: Metrics.modal.height)
        }
    }
}
