import SwiftUI

struct Sidebar: View {
    @Binding var session: Session
    
    var body: some View {
        VStack {
            Button {
                UIApplication.shared.resign()
                withAnimation(.easeInOut(duration: 0.3)) {
                    session.section = .projects
                }
            } label: { }.buttonStyle(Style(image: "paperplane.fill", selected: session.section == .projects))
            Button {
                UIApplication.shared.resign()
                withAnimation(.easeInOut(duration: 0.3)) {
                    session.section = .activity
                }
            } label: { }.buttonStyle(Style(image: "chart.bar.fill", selected: session.section == .settings))
            Button {
                UIApplication.shared.resign()
                withAnimation(.easeInOut(duration: 0.3)) {
                    session.section = .capacity
                }
            } label: { }.buttonStyle(Style(image: "square.stack.fill", selected: session.section == .capacity))
            Button {
                UIApplication.shared.resign()
                withAnimation(.easeInOut(duration: 0.3)) {
                    session.section = .settings
                }
            } label: { }.buttonStyle(Style(image: "gear", selected: session.section == .settings))
            Spacer()
        }
        .frame(width: Metrics.sidebar.width)
    }
}
