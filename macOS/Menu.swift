import AppKit

final class Menu: NSMenu, NSMenuDelegate {
    private let status = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    init() {
        super.init(title: "")
        items = [app, file, edit, window, help]
        status.button!.image = NSImage(named: "status")
        status.button!.target = self
        status.button!.action = #selector(triggerStatus)
    }
    
    private var app: NSMenuItem {
        .parent("Avocado", [
                    .child("About", #selector(NSApplication.orderFrontStandardAboutPanel(_:))),
                    .separator(),
                    .child("Preferences...", #selector(NSApplication.showPreferencesWindow), ","),
                    .separator(),
                    .child("Purchases", #selector(NSApplication.store), ""),
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
                    .child("Select All", #selector(NSText.selectAll), "a"),
                    .separator(),
                    .child("Find", #selector(NSText.selectAll), "f")])
    }
    
    private var window: NSMenuItem {
        .parent("Window") {
            $0.submenu!.delegate = self
        }
    }
    
    private var help: NSMenuItem {
        .parent("Help")
    }
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        switch menu.title {
        case "File":
            var board = false
            var add = false
            var save = false
            switch session.state.value {
            case .view:
                board = true
            case .create, .column, .card:
                add = true
            case .edit:
                save = true
            default:
                break
            }
            
            menu.items = [
                .child("New Project", #selector(triggerNewProject), "") {
                    $0.target = self
                },
                .child("New Column", #selector(triggerNewColumn), "") {
                    $0.target = self
                    $0.isEnabled = board
                },
                .child("New Card", #selector(triggerNewCard), "n") {
                    $0.target = self
                    $0.isEnabled = board
                },
                .separator(),
                add
                    ? .child("Add", #selector(triggerAdd), "s") {
                        $0.target = self
                        $0.isEnabled = add
                    } : .child("Save", #selector(triggerSave), "s") {
                        $0.target = self
                        $0.isEnabled = save
                    },
                .child("Cancel", #selector(triggerCancel), "x") {
                    $0.target = self
                    $0.isEnabled = add || save
                    $0.keyEquivalentModifierMask = [.command, .option]
                },
                .separator(),
                .child("Close Window", #selector(NSWindow.close), "w")]
        case "Window":
            menu.items = [
                .child("Minimize", #selector(NSWindow.miniaturize), "m"),
                .child("Zoom", #selector(NSWindow.zoom), "p"),
                .separator(),
                .child("Bring All to Front", #selector(NSApplication.arrangeInFront)),
                .separator()]
                + (0 ..< NSApp.windows.count)
                .compactMap {
                    switch NSApp.windows[$0] {
                    case is Window:
                        return (index: $0, title: "Avocado")
                    case is Store:
                        return (index: $0, title: "Purchases")
//                    case is About:
//                        return (index: $0, title: NSLocalizedString("About", comment: ""))
                    default:
                        return nil
                    }
                }
                .map { (index: Int, title: String) in
                    .child(title, #selector(triggerFocus)) {
                        $0.target = self
                        $0.tag = index
                        $0.state = NSApp.mainWindow == NSApp.windows[index] ? .on : .off
                    }
                }
        default:
            break
        }
    }
    
    @objc private func triggerStatus(_ button: NSStatusBarButton) {
        let activity = Activity()
        activity.behavior = .transient
        activity.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        activity.contentViewController!.view.window!.makeKey()
    }
    
    @objc private func triggerNewProject() {
        session.newProject()
    }
    
    @objc private func triggerNewColumn() {
        session.newColumn()
    }
    
    @objc private func triggerNewCard() {
        session.newCard()
    }
    
    @objc private func triggerAdd() {
        session.add()
    }
    
    @objc private func triggerSave() {
        session.save()
    }
    
    @objc private func triggerCancel() {
        session.cancel()
    }
    
    @objc private func triggerFocus(_ item: NSMenuItem) {
        NSApp.windows[item.tag].makeKeyAndOrderFront(nil)
    }
}
