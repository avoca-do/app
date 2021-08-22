import SwiftUI

struct Empty: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image(session.archive.isEmpty ? "welcome" : "choose")
                Text(session.archive.isEmpty ? "Start your first project" : "Choose a project")
                    .foregroundColor(.secondary)
                    .padding()
                if session.archive.isEmpty {
                    Button {
                        session.newProject()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                            Text("Start")
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 36)
                        }
                    }
                    .fixedSize()
                    .padding()
                }
            }
        }
        .navigationBarTitle(session.archive.isEmpty ? "Welcome" : "Ready", displayMode: .inline)
    }
}
