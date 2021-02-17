import AppKit
import Combine

final class Window: NSWindow {
    private weak var sidebar: Sidebar!
    private var subs = Set<AnyCancellable>()
    
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

        let sidebar = Sidebar()
        
        sidebar.projects.click.sink { [weak self] in
            self?.projects()
        }.store(in: &subs)
        
        sidebar.capacity.click.sink { [weak self] in
            self?.capacity()
        }.store(in: &subs)
        
        contentView!.addSubview(sidebar)
        self.sidebar = sidebar
        
        sidebar.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        sidebar.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        sidebar.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        
        projects()
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
    
    override func becomeMain() {
        super.becomeMain()
        contentView!.subviews.forEach {
            $0.alphaValue = 1
        }
    }
    
    override func resignMain() {
        super.resignMain()
        contentView!.subviews.forEach {
            $0.alphaValue = 0.5
        }
    }
    
    private func projects() {
        select(sidebar.projects)
    }
    
    private func capacity() {
        select(sidebar.capacity)
    }
    
    private func select(_ item: Sidebar.Item) {
        [sidebar.projects, sidebar.capacity].forEach {
            $0.state = $0 == item ? .selected : .on
        }
    }
}
