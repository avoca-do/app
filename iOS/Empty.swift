import SwiftUI

struct Empty: View {
    @Binding var session: Session
    
    var body: some View {
        VStack {
            Image(session.archive.isEmpty ? "welcome" : "choose")
            Text(session.archive.isEmpty ? "Start your first project" : "Choose a project")
                .foregroundColor(.secondary)
                .padding()
            if session.archive.isEmpty {
                Actioner(title: "Start") {
                    session.newProject()
                }
            }
        }
        .navigationBarTitle(session.archive.isEmpty ? "Welcome" : "Ready", displayMode: .inline)
    }
}
