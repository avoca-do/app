import SwiftUI
import Kanban

struct Editor: UIViewRepresentable {
    @Binding var session: Session
    let board: Int
    let card: Position?
    @Environment(\.presentationMode) var visible
    
    func makeCoordinator() -> Coordinator {
        .init(wrapper: self)
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator
    }
    
    func updateUIView(_ uiView: Coordinator, context: Context) { }
}
