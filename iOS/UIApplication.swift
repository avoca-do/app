import WebKit

extension UIApplication {
    static var dark: Bool { shared.windows.map(\.rootViewController?.traitCollection.userInterfaceStyle).first == .dark }
    
    func resign() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func share(_ any: Any) {
        let controller = UIActivityViewController(activityItems: [any], applicationActivities: nil)
        controller.popoverPresentationController?.sourceView = windows.first?.rootViewController?.presentedViewController?.view
        windows.first?.rootViewController?.presentedViewController?.present(controller, animated: true)
    }
    
    func settings() {
        open(URL(string: Self.openSettingsURLString)!)
    }
}
