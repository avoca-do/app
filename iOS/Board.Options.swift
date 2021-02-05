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
                            RoundedRectangle(cornerRadius: 16)
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
                                            .frame(width: 60, height: 60)
                                    }
                                }
                                .contentShape(Rectangle())
                                .padding(.bottom)
                                
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
                        .highPriorityGesture(
                            DragGesture(coordinateSpace: .global)
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
