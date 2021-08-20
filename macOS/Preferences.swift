import AppKit
import Combine

final class Preferences: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 400, height: 280),
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        titlebarAppearsTransparent = true
        isReleasedWhenClosed = false
        title = NSLocalizedString("Preferences", comment: "")
        center()
        setFrameAutosaveName("Preferences")
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .sidebar
        contentView = content
        
        let tab = NSTabView()
        tab.translatesAutoresizingMaskIntoConstraints = false
        tab.addTabViewItem(Features())
        tab.addTabViewItem(Notifications())
        contentView!.addSubview(tab)
        
        tab.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        tab.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -10).isActive = true
        tab.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 10).isActive = true
        tab.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -10).isActive = true
    }
}
