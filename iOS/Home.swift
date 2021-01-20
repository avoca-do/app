import SwiftUI

struct Home: View {
    @Binding var session: Session
    
    var body: some View {
        ScrollView {
            
        }
        VStack {
            Spacer()
            Field(session: $session)
            if !session.typing {
                HStack {
                    Control.Circle(state: .ready, image: "square.stack") {
                        
                    }
                    Control.Circle(state: .ready, image: "slider.horizontal.3") {
                    
                    }
                    Control.Circle(state: .ready, image: "plus") {
                        session.become.send()
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}
