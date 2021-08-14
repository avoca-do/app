import AppKit

final class Find: NSPanel {
    static let width = CGFloat(480)
    
    deinit {
        print("find gone")
    }
    
    init() {
        print("find init")
        super.init(contentRect: .init(x: 0, y: 0, width: Self.width, height: 320), styleMask: [.borderless], backing: .buffered, defer: true)
        isMovableByWindowBackground = true
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        
        let content = NSVisualEffectView(frame: frame)
        content.material = .hudWindow
        content.state = .active
        content.wantsLayer = true
        content.layer!.cornerRadius = 20
        
        contentView!.addSubview(content)
        center()
        
        var monitor: Any?
        monitor = NSEvent.addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { [weak self] event in
            guard event.window != self else { return event }
            monitor
                .map(NSEvent.removeMonitor)
            self?.close()
            return nil
        }
    }
}
