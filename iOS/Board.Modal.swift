import SwiftUI

extension Board {
    struct Modal: View {
        @Binding var session: Session
        let board: Int
        @State private var card: (Int, Int)?
        @State private var offset = CGFloat(Frame.modal.height)
        
        var body: some View {
            ZStack {
                if card != nil {
                    Color.black.opacity(0.8)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.accentColor)
                            VStack {
                                Rectangle()
                                    .fill(Color.background)
                                    .padding(.top, 60)
                            }
                            VStack {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        offset = Frame.modal.height
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        session.card.send(nil)
                                    }
                                } label: {
                                    HStack {
                                        Text(verbatim: session[board][card!.0, card!.1])
                                            .lineLimit(2)
                                            .font(Font.caption.bold())
                                            .padding(.horizontal)
                                            .padding(.leading)
                                        Spacer()
                                        Image(systemName: "xmark")
                                            .font(Font.callout.bold())
                                            .frame(width: 60, height: 60)
                                        
                                    }
                                }
                                .contentShape(Rectangle())
                                .foregroundColor(.black)
                                .frame(height: 60)
                                .padding(.bottom)
                                
                                if card!.0 < session[board].count - 1 {
                                    Option(text: "Move to " + session[board][card!.0].title, image: "arrow.right") {
                                        
                                    }
                                }
                                
                                Option(text: "Move", image: "move.3d") {
                                    
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
    }
}
