import SwiftUI
import Kanban

extension Board {
    struct Options: View {
        @Binding var session: Session
        @State private var offset = CGFloat(Metrics.modal.height)
        @State private var move = false
        
        var body: some View {
            ZStack {
                if case .card = session.path {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture(perform: dismiss)
                    VStack {
                        Spacer()
                        Content(session: $session, dismiss: dismiss)
                            .offset(y: Metrics.modal.offset + offset)
                            .highPriorityGesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            offset = max(gesture.translation.height, Metrics.modal.min)
                                        }
                                    }
                                    .onEnded {
                                        if $0.translation.height > Metrics.modal.max {
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
            .onChange(of: session.path) {
                if case .card = $0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            offset = 0
                        }
                    }
                }
            }
        }
        
        private func dismiss() {
            withAnimation(.easeInOut(duration: 0.4)) {
                offset = Metrics.modal.height
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                session.path = session.path.board
            }
        }
    }
}
