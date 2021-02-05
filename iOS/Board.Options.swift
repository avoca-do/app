import SwiftUI
import Kanban

extension Board {
    struct Options: View {
        @Binding var session: Session
        let board: Int
        @State private var card: Position!
        @State private var offset = CGFloat(Frame.modal.height)
        @State private var move = false
        
        var body: some View {
            ZStack {
                if card != nil {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture(perform: dismiss)
                    VStack {
                        Spacer()
                        Content(session: $session, card: $card, board: board, dismiss: dismiss)
                            .offset(y: Frame.modal.offset + offset)
                            .highPriorityGesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            offset = max(gesture.translation.height, -100)
                                        }
                                    }
                                    .onEnded {
                                        if $0.translation.height > 100 {
                                            dismiss()
                                        } else {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                offset = 0
                                            }
                                        }
                                    }
                            )
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .onReceive(session.card) { new in
                if new != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            offset = 0
                        }
                    }
                }
                card = new
            }
        }
        
        private func dismiss() {
            withAnimation(.easeInOut(duration: 0.4)) {
                offset = Frame.modal.height
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                session.card.send(nil)
            }
        }
    }
}
