import SwiftUI

struct Editor: UIViewRepresentable {
    @Binding var session: Session
    let board: Int
    @Environment(\.presentationMode) var visible
    
    func makeCoordinator() -> Coordinator {
        .init(wrapper: self)
    }
    
    func makeUIView(context: Context) -> Coordinator {
        context.coordinator
    }
    
    func updateUIView(_ uiView: Coordinator, context: Context) { }
}
