import SwiftUI

struct Home: View {
    @Binding var session: Session
    
    var body: some View {
        ScrollView {
            
        }
        VStack {
            Spacer()
            HStack {
                Control.Circle(state: .ready, image: "square.stack.3d.up") {
                    
                }
                Control.Circle(state: .ready, image: "slider.horizontal.3") {
                
                }
                Control.Circle(state: .ready, image: "plus") {
                    
                }
            }
            .padding(.bottom, 20)
        }
    }
}
