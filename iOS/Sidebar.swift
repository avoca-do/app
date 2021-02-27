import SwiftUI

struct Sidebar: View {
    @Binding var session: Session
    
    var body: some View {
        VStack {
            Button {
                session.section = .projects
            } label: { }.buttonStyle(Style(image: "paperplane.fill", selected: session.section == .projects))
            Button {
                session.section = .capacity
            } label: { }.buttonStyle(Style(image: "square.stack.fill", selected: session.section == .capacity))
            Button {
                session.section = .settings
            } label: { }.buttonStyle(Style(image: "gear", selected: session.section == .settings))
            Spacer()
        }
        .frame(width: Metrics.sidebar.width)
    }
}
