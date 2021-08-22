import UserNotifications

enum Notifications {
    static func send(message: String) {
        UNUserNotificationCenter
            .current()
            .getNotificationSettings { settings in
                if settings.alertSetting == .enabled && settings.authorizationStatus == .authorized {
                    let content = UNMutableNotificationContent()
                    content.body = message
                    UNUserNotificationCenter.current().add(.init(identifier: UUID().uuidString, content: content, trigger: nil))
                }
        }
    }
}
