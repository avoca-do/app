import SwiftUI
import UserNotifications
import Kanban

struct Settings: View {
    @Binding var session: Session
    @AppStorage(Defaults.Key.spell.rawValue) private var spell = true
    @AppStorage(Defaults.Key.correction.rawValue) private var correction = false
    @State private var requested = false
    
    var body: some View {
        Popup(title: "Settings", leading: { }) {
            List {
                Section(header: Text("Features")) {
                    Toggle("Spell checking", isOn: $spell)
                    Toggle("Auto correction", isOn: $correction)
                }
                Section(header: Text("Notifications")
                        , footer: Text("Show notifications of important events. Avocado will never send Push Notifications and all notifications will appear only while using the app.")) {
                    if requested {
                        HStack {
                            Text("Status")
                                .foregroundColor(.secondary)
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    } else {
                        Button("Allow notifications") {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { success, error in
                                if success {
                                    requested = true
                                }
                            }
                        }
                    }
                }
                Section {
                    
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
        .onAppear {
            UNUserNotificationCenter.current().getNotificationSettings {
                requested = $0.alertSetting == .enabled
            }
        }
    }
}
