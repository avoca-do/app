import AppKit

extension NSApplication {
    @objc func store() {
        (anyWindow() ?? Store())
            .makeKeyAndOrderFront(nil)
    }
    
    func anyWindow<T>() -> T? {
        windows
            .compactMap {
                $0 as? T
            }
            .first
    }
    
    @objc func showPreferencesWindow(_ sender: Any?) {
//        (anyWindow() ?? Settings())
//            .makeKeyAndOrderFront(nil)
    }
    
    private var activeWindow: Window? {
        keyWindow as? Window ?? anyWindow()
    }
}
