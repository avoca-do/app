import SwiftUI
import Kanban

struct Settings: View {
    @Binding var session: Session
    @AppStorage(Defaults.Key.spell.rawValue) private var spell = true
    @AppStorage(Defaults.Key.correction.rawValue) private var correction = false
    
    var body: some View {
        Popup(title: "Settings", leading: { }) {
            List {
                Section(header: Text("Features")) {
                    Toggle("Spell checking", isOn: $spell)
                    Toggle("Auto correction", isOn: $correction)
                }
                Section(header: Text("In-App Purchases")) {
                    Button("Capacity") {
                        session.modal.send(.store)
                    }
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .listStyle(GroupedListStyle())
        }
    }
}
