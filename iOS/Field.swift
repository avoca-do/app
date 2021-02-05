import SwiftUI

struct Field: UIViewRepresentable {
    @Binding var session: Session
    let board: Int?
    
    func makeCoordinator() -> Coordinator {
        .init(wrapper: self)
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator
    }
    
    func updateUIView(_ uiView: Coordinator, context: Context) { }
}
