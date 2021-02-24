import AppKit
import Combine

final class Menu: NSMenu, NSMenuDelegate {
    private var sub: AnyCancellable?
    private var editing = false
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    init() {
        super.init(title: "")
        items = [app, file, edit, window, help]
        sub = Session.edit.removeDuplicates().sink { [weak self] in
            self?.editing = $0 != nil
        }
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        switch menu.title {
        case "File":
            let projects = NSApp.keyWindow?.titlebarAccessoryViewControllers.first?.view is Projects.Titlebar
            menu.items = [
                .child("New Project", #selector(triggerProject), "n") {
                    $0.target = self
                    $0.isEnabled = projects
                },
                .child("New Card", #selector(triggerCard), "N") {
                    $0.target = self
                    $0.isEnabled = projects
                },
                .separator(),
                .child("Columns", #selector(triggerColumns)) {
                    $0.target = self
                    $0.isEnabled = projects
                },
                .child("Settings", #selector(triggerSettings)) {
                    $0.target = self
                    $0.isEnabled = projects
                },
                .separator(),
                .child("Save", #selector(Edit.Text.send), "s") {
                    $0.isEnabled = projects && editing
                },
                .separator(),
                .child("Cancel", #selector(cancel), "X") {
                    $0.target = self
                    $0.isEnabled = projects && editing
                }]
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
        .parent("File") {
            $0.submenu!.delegate = self
            $0.submenu!.autoenablesItems = false
        }
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
    
    @objc private func triggerProject() {
        (NSApp.keyWindow?.titlebarAccessoryViewControllers.first?.view as? Projects.Titlebar)?.triggerProject()
    }
    
    @objc private func triggerCard() {
        (NSApp.keyWindow?.titlebarAccessoryViewControllers.first?.view as? Projects.Titlebar)?.triggerCard()
    }
    
    @objc private func triggerSettings() {
        (NSApp.keyWindow?.titlebarAccessoryViewControllers.first?.view as? Projects.Titlebar)?.triggerSettings()
    }
    
    @objc private func triggerColumns() {
        (NSApp.keyWindow?.titlebarAccessoryViewControllers.first?.view as? Projects.Titlebar)?.triggerColumns()
    }
    
    @objc private func cancel() {
        Session.edit.send(nil)
    }
    
    @objc private func focus(_ item: NSMenuItem) {
        NSApp.windows[item.tag].makeKeyAndOrderFront(nil)
    }
}
