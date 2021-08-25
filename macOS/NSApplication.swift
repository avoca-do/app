import AppKit

extension NSApplication {
    @objc func store() {
        (anyWindow() ?? Store())
            .makeKeyAndOrderFront(nil)
    }
    
    @objc func showPreferencesWindow(_ sender: Any?) {
        (anyWindow() ?? Preferences())
            .makeKeyAndOrderFront(nil)
    }
    
    @objc func find(_ sender: Any?) {
        (anyWindow() ?? Find())
            .makeKeyAndOrderFront(nil)
    }
    
    @objc func hideFind(_ sender: Any?) {
        if let find: Find = anyWindow() {
            find.close()
        }
    }
    
    @objc func show() {
        (anyWindow() as Window?)?
            .orderFrontRegardless()
    }
    
    func anyWindow<T>() -> T? {
        windows
            .compactMap {
                $0 as? T
            }
            .first
    }
}
