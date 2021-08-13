import AppKit

extension NSApplication {
    @objc func store() {
        (anyWindow() ?? Store())
            .makeKeyAndOrderFront(nil)
    }
    
    @objc func showPreferencesWindow(_ sender: Any?) {
//        (anyWindow() ?? Settings())
//            .makeKeyAndOrderFront(nil)
    }
    
    @objc func find(_ sender: Any?) {
        if let find: Find = anyWindow() {
            find.makeKeyAndOrderFront(nil)
        } else if let window: Window = anyWindow() {
            window.addChildWindow(Find(), ordered: .above)
        }
    }
    
    @objc func hideFind(_ sender: Any?) {
        if let find: Find = anyWindow() {
            find.close()
        }
    }
    
    private func anyWindow<T>() -> T? {
        windows
            .compactMap {
                $0 as? T
            }
            .first
    }
}
