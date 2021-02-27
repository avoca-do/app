import SwiftUI

struct Sidebar: View {
    @Binding var session: Session
    
    var body: some View {
        VStack {
            Button {
                
            } label: { }.buttonStyle(Style(image: "paperplane.fill", selected: false))
            Button {
                
            } label: { }.buttonStyle(Style(image: "square.stack.fill", selected: false))
            Button {
                
            } label: { }.buttonStyle(Style(image: "slider.horizontal.3", selected: false))
            Spacer()
        }
        .frame(width: Metrics.sidebar.width)
        .padding([.top, .leading])
    }
}
