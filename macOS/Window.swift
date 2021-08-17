import AppKit

final class Window: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0,
                                      y: 0,
                                      width: NSScreen.main!.frame.width * 0.5,
                                      height: NSScreen.main!.frame.height * 0.5),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView],
                   backing: .buffered,
                   defer: false)
        minSize = .init(width: 600, height: 300)
        toolbar = .init()
        isReleasedWhenClosed = false
        center()
        setFrameAutosaveName("Window")
        tabbingMode = .disallowed
        titlebarAppearsTransparent = true
        
        let base = NSVisualEffectView()
        base.state = .active
        base.material = .popover
        contentView = base
        
        let sidebar = Sidebar()
        base.addSubview(sidebar)
        
        let content = Content()
        base.addSubview(content)
        
        sidebar.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        sidebar.leftAnchor.constraint(equalTo: base.leftAnchor).isActive = true
        sidebar.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true
        
        content.topAnchor.constraint(equalTo: base.topAnchor).isActive = true
        content.bottomAnchor.constraint(equalTo: base.bottomAnchor).isActive = true
        content.leftAnchor.constraint(equalTo: sidebar.rightAnchor).isActive = true
        content.rightAnchor.constraint(equalTo: base.rightAnchor).isActive = true
        
        let bar = Bar()
        delegate = bar
        let accessory = NSTitlebarAccessoryViewController()
        accessory.view = bar
        accessory.layoutAttribute = .top
        addTitlebarAccessoryViewController(accessory)
    }
    
    override func cancelOperation(_ sender: Any?) {
        super.cancelOperation(sender)
        session.cancel()
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
}
