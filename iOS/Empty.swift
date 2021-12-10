import SwiftUI

struct Empty: View {
    @Binding var session: Session
    
    var body: some View {
        VStack {
            Text(session.archive.isEmpty ? "Start your first project" : "Choose a project")
                .foregroundColor(.secondary)
                .padding()
            if session.archive.isEmpty {
                Actioner(title: "Start", action: session.newProject)
            }
        }
        .navigationBarTitle(session.archive.isEmpty ? "Welcome" : "Ready", displayMode: .inline)
    }
}
