import SwiftUI
import Kanban

struct Settings: View {
    @Binding var session: Session
    @AppStorage(Defaults.Key.spell.rawValue) private var spell = true
    @AppStorage(Defaults.Key.correction.rawValue) private var correction = false
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        VStack {
            Text("Features")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding([.leading, .top], 30)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
            Switch(text: "Spell checking", value: $spell)
            Switch(text: "Auto correction", value: $correction)
            Spacer()
        }
    }
}
