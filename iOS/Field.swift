import SwiftUI
import Kanban

struct Field: UIViewRepresentable {
    @Binding var session: Session
    let write: Write
    
    func makeCoordinator() -> Coordinator {
        .init(wrapper: self)
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator
    }
    
    func updateUIView(_: Coordinator, context: Context) { }
}
