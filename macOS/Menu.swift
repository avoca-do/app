import AppKit
import Combine

final class Menu: NSMenu, NSMenuDelegate {
    private var sub: AnyCancellable?
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    init() {
        super.init(title: "")
        items = [app, file, edit, window, help]
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        switch menu.title {
        case "Window":
            menu.items = [
                .child("Minimize", #selector(NSWindow.miniaturize), "m"),
                .child("Zoom", #selector(NSWindow.zoom), "p"),
                .separator(),
                .child("Bring All to Front", #selector(NSApplication.arrangeInFront)),
                .separator()] + ((0 ..< NSApp.windows.count).filter {
                    NSApp.windows[$0] is Window || NSApp.windows[$0] is NSPanel
                }.map { index in
                    return NSMenuItem.child(NSApp.windows[index] is Window
                                                ? "Avocado"
                                                : NSApp.windows[index] is NSPanel
                                                    ? "About"
                                                    : NSApp.windows[index].title,
                                            #selector(focus)) {
                        $0.target = self
                        $0.tag = index
                        $0.state = NSApp.keyWindow == NSApp.windows[index] ? .on : .off
                    }
                })
        default: break
        }
    }

    private var app: NSMenuItem {
        .parent("Avocado", [
                    .child("About", #selector(NSApplication.orderFrontStandardAboutPanel(_:))),
                    .separator(),
                    .child("Preferences...", #selector(App.preferences), ","),
                    .separator(),
                    .child("Hide", #selector(NSApplication.hide), "h"),
                    .child("Hide Others", #selector(NSApplication.hideOtherApplications), "h") {
                        $0.keyEquivalentModifierMask = [.option, .command]
                    },
                    .child("Show all", #selector(NSApplication.unhideAllApplications)),
                    .separator(),
                    .child("Quit", #selector(NSApplication.terminate), "q")])
    }
    
    private var file: NSMenuItem {
        .parent("File", [
                    .child("New Window", #selector(App.preferences), "n"),
                    .separator(),
                    .child("Close", #selector(Window.close), "w"),
                    .separator()])
    }
    
    private var edit: NSMenuItem {
        .parent("Edit", [
                    .child("Undo", Selector(("undo:")), "z"),
                    .child("Redo", Selector(("redo:")), "Z"),
                    .separator(),
                    .child("Cut", #selector(NSText.cut), "x"),
                    .child("Copy", #selector(NSText.copy(_:)), "c"),
                    .child("Paste", #selector(NSText.paste), "v"),
                    .child("Delete", #selector(NSText.delete)),
                    .child("Select All", #selector(NSText.selectAll), "a")])
    }
    
    private var window: NSMenuItem {
        .parent("Window") {
            $0.submenu!.delegate = self
        }
    }
    
    private var help: NSMenuItem {
        .parent("Help")
    }
    
    @objc private func focus(_ item: NSMenuItem) {
        NSApp.windows[item.tag].makeKeyAndOrderFront(nil)
    }
}
