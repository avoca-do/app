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
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                
                Section(header: Text("In-App Purchases")) {
                    Button("Capacity") {
                        session.modal.send(.store)
                    }
                }
                Section(header: Text("Notifications")
                        , footer: Text("""
Show notifications of important events.
Avocado will never send you Push Notifications, and all notifications will appear only while you are using the app.

Your privacy is respected at all times.
""")) {
                    if requested {
                        HStack {
                            Text("Notifications allowed")
                                .foregroundColor(.secondary)
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    } else {
                        Button("Allow notifications") {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { success, error in
                                DispatchQueue.main.async {
                                    if success {
                                        requested = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
        }
        .onAppear {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    requested = settings.alertSetting == .enabled && settings.authorizationStatus == .authorized
                }
            }
        }
    }
}
