import SwiftUI
import Kanban

struct Settings: View {
    @Binding var session: Session
    @AppStorage(Defaults.Key.spell.rawValue) private var spell = true
    @AppStorage(Defaults.Key.correction.rawValue) private var correction = false
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        VStack(spacing: 0) {
            Title(session: $session, title: "Settings")
            ScrollView {
                HStack {
                    Text("Features")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.leading)
                    Spacer()
                }
                .padding(.top, 40)
                Switch(text: "Spell checking", value: $spell)
                Switch(text: "Auto correction", value: $correction)
            }
        }
    }
}
