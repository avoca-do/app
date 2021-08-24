import SwiftUI

extension Find {
    struct Bar: UIViewRepresentable {
        @Binding var session: Session
        @Binding var search: String
        @Environment(\.presentationMode) var visible
        
        func makeCoordinator() -> Coordinator {
            .init(wrapper: self)
        }
        
        func makeUIView(context: Context) -> Coordinator {
            context.coordinator
        }
        
        func updateUIView(_: Coordinator, context: Context) {
            
        }
    }
}
