import AppKit

final class Window: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: NSScreen.main!.frame.width * 0.6, height: NSScreen.main!.frame.height * 0.6),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
        minSize = .init(width: 400, height: 200)
        toolbar = .init()
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        center()
        setFrameAutosaveName("Window")
        
        let accesory = NSTitlebarAccessoryViewController()
        accesory.view = NSView()
        accesory.layoutAttribute = .top
        addTitlebarAccessoryViewController(accesory)
        
        let a = NSView()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.wantsLayer = true
        a.layer!.backgroundColor = .init(gray: 0.2, alpha: 1)
        
        let b = NSView()
        b.wantsLayer = true
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer!.backgroundColor = .init(gray: 0.8, alpha: 1)
        
        let split = NSSplitView()
        split.isVertical = true
        split.translatesAutoresizingMaskIntoConstraints = false
//        split.addArrangedSubview(a)
//        split.addArrangedSubview(b)
        split.insertArrangedSubview(a, at: 0)
        split.insertArrangedSubview(b, at: 1)
        split.adjustSubviews()
        split.coll
        contentView!.addSubview(split)
        
        print(split.isSubviewCollapsed(a))
        print(split.isSubviewCollapsed(b))
        
        split.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor).isActive = true
        split.bottomAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.bottomAnchor).isActive = true
        split.leftAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.leftAnchor).isActive = true
        split.rightAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
}
