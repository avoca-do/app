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
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.background)
                            VStack {
                                Button(action: dismiss) {
                                    HStack {
                                        if session[board][card.column].count > card.index {
                                            Text(verbatim: session[board][card.column, card.index])
                                                .lineLimit(1)
                                                .foregroundColor(.primary)
                                                .padding(.horizontal)
                                        }
                                        Spacer()
                                        Image(systemName: "xmark")
                                            .font(.callout)
                                            .foregroundColor(.secondary)
                                            .frame(width: 60, height: 50)
                                    }
                                }
                                .contentShape(Rectangle())
                                .padding(.vertical)
                                
                                if session[board][card.column].count > card.index {
                                    if card.column < session[board].count - 1 {
                                        Option(text: "Move to " + session[board][card.column + 1].title, image: "arrow.right") {
                                            session[board][horizontal: card.column, card.index] = card.column + 1
                                            dismiss()
                                        }
                                    }
                                }
                                
                                Option(text: "Move", image: "move.3d") {
                                    move = true
                                }
                                .sheet(isPresented: $move) {
                                    Move(session: $session, card: $card, board: board)
                                }
                                Option(text: "Edit", image: "text.redaction") {
                                    
                                }
                                Option(text: "Delete", image: "trash") {
                                    
                                }
                                Spacer()
                            }
                        }
                        .frame(height: Frame.modal.height)
                        .offset(y: Frame.modal.offset + offset)   
                    }
                    .edgesIgnoringSafeArea(.bottom)
                }
            }
            .onReceive(session.card) { new in
                if new != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            offset = 0
                        }
                    }
                }
                card = new
            }
        }
        
        private func dismiss() {
            withAnimation(.easeInOut(duration: 0.3)) {
                offset = Frame.modal.height
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                session.card.send(nil)
            }
        }
    }
}
