import SwiftUI

extension Home {
    struct Projects: View {
        @Binding var session: Session
        
        var body: some View {
            if session.archive.isEmpty(.archive) {
                Text("No projects")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            } else {
                ScrollView {
                    
                }
            }
        }
    }
}
