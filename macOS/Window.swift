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
        
        let accessory = NSTitlebarAccessoryViewController()
        accessory.view = Bar()
        accessory.layoutAttribute = .top
        addTitlebarAccessoryViewController(accessory)
    }
    
    override func cancelOperation(_ sender: Any?) {
        switch session.state.value {
        case .create:
            session
                .state
                .send(.none)
        case let .new(path), let .edit(path):
            session
                .state
                .send(.view(path.board))
        default:
            super.cancelOperation(sender)
        }
    }
    /*
    override func close() {
        session
            .tab
            .items
            .value
            .ids
            .forEach(session.close.send)
        super.close()
    }
    
    @objc func plus() {
        session
            .plus
            .send()
    }
    
    @objc func closeTab() {
        session
            .close
            .send(session
                    .current
                    .value)
    }
    
    @objc func stop() {
        session.stop.send(session.current.value)
    }

    @objc func reload() {
        session.reload.send(session.current.value)
    }

    @objc func actualSize() {
        session.actualSize.send(session.current.value)
    }

    @objc func zoomIn() {
        session.zoomIn.send(session.current.value)
    }

    @objc func zoomOut() {
        session.zoomOut.send(session.current.value)
    }
    
    @objc func tryAgain() {
        switch session
            .tab
            .items
            .value[state: session.current.value] {
        case let .error(browse, error):
            cloud
                .browse(error.url, browse: browse) { [weak self] in
                    guard let id = self?.session.current.value else { return }
                    self?
                        .session
                        .tab
                        .browse(id, browse)
                    self?
                        .session
                        .load
                        .send((id: id, access: $1))
                }
        default: break
        }
    }
    
    @objc func location() {
        session
            .search
            .send(session
                    .current
                    .value)
    }
    
    @objc func nextTab() {
        session
            .tab
            .items
            .value
            .ids
            .firstIndex(of: session.current.value)
            .map {
                session
                    .current
                    .send($0 < session.tab.items.value.count - 1 ? session.tab.items.value.ids[$0 + 1] : session.tab.items.value.ids.first!)
            }
    }
    
    @objc func previousTab() {
        session
            .tab
            .items
            .value
            .ids
            .firstIndex(of: session.current.value)
            .map {
                session
                    .current
                    .send($0 > 0 ? session.tab.items.value.ids[$0 - 1] : session.tab.items.value.ids.last!)
            }
    }
    
    override func performTextFinderAction(_ sender: Any?) {
        (NSApp.keyWindow as? Window)
            .map {
                $0
                    .contentView?
                    .subviews
                    .compactMap {
                        $0 as? Browser
                    }
                    .first
                    .map {
                        $0.performTextFinderAction(sender)
                    }
            }
    }*/
}

/*import AppKit
import Combine

final class Window: NSWindow {
    private weak var sidebar: Sidebar!
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: NSScreen.main!.frame.width * 0.6, height: NSScreen.main!.frame.height * 0.6),
                   styleMask: [.closable, .miniaturizable, .resizable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
        minSize = .init(width: 800, height: 400)
        toolbar = .init()
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        center()
        setFrameAutosaveName("Window")

        let accesory = NSTitlebarAccessoryViewController()
        accesory.view = .init()
        accesory.layoutAttribute = .top
        addTitlebarAccessoryViewController(accesory)
        
        let sidebar = Sidebar()
        
        sidebar.projects.click.sink { [weak self] in
            self?.projects()
        }.store(in: &subs)
        
        sidebar.activity.click.sink { [weak self] in
            self?.activity()
        }.store(in: &subs)
        
        sidebar.capacity.click.sink { [weak self] in
            self?.capacity()
        }.store(in: &subs)
        
        contentView!.addSubview(sidebar)
        self.sidebar = sidebar
        
        sidebar.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        sidebar.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        sidebar.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        
        Session.capacity.sink { [weak self] in
            self?.capacity()
        }.store(in: &subs)
        
        projects()
    }
    
    override func close() {
        super.close()
        NSApp.terminate(nil)
    }
    
    override func becomeMain() {
        super.becomeMain()
        dim(1)
    }
    
    override func resignMain() {
        super.resignMain()
        dim(0.5)
    }
    
    private func projects() {
        select(sidebar.projects)
        show(Projects())
        titlebarAccessoryViewControllers.first!.view = Projects.Titlebar()
    }
    
    private func activity() {
        select(sidebar.activity)
        show(Activity())
        titlebarAccessoryViewControllers.first!.view = Activity.Titlebar()
    }
    
    private func capacity() {
        select(sidebar.capacity)
        show(Capacity())
        titlebarAccessoryViewControllers.first!.view = Capacity.Titlebar()
    }
    
    private func show(_ view: NSView) {
        contentView!.subviews.filter {
            !($0 is Sidebar)
        }.forEach {
            $0.removeFromSuperview()
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(view)
        view.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 1).isActive = true
        view.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor, constant: -1).isActive = true
        view.leftAnchor.constraint(equalTo: sidebar.rightAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -1).isActive = true
    }
    
    private func select(_ item: Sidebar.Item) {
        Session.edit.send(nil)
        [sidebar.projects, sidebar.activity, sidebar.capacity].forEach {
            $0.state = $0 == item ? .selected : .on
        }
    }
    
    private func dim(_ opacity: CGFloat) {
        (contentView!.subviews + [titlebarAccessoryViewControllers.first!.view]).forEach {
            $0.alphaValue = opacity
        }
    }
}
*/
