import AppKit

final class Find: NSPanel {
    static let width = CGFloat(480)
    private var monitor: Any?
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: Self.width, height: 320), styleMask: [.borderless], backing: .buffered, defer: true)
        isMovableByWindowBackground = true
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        
        let blur = NSVisualEffectView(frame: frame)
        blur.material = .hudWindow
        blur.state = .active
        blur.wantsLayer = true
        blur.layer!.cornerRadius = 14
        contentView!.addSubview(blur)
        
        let content = Content(frame: frame)
        blur.addSubview(content)
        
        center()
        
        monitor = NSEvent
            .addLocalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { [weak self] event in
                guard event.window != self else { return event }
                self?.close()
                return nil
            }
    }
    
    override func close() {
        super.close()
        monitor
            .map(NSEvent.removeMonitor)
    }
    
    override func makeFirstResponder(_ responder: NSResponder?) -> Bool {
        if responder is Field || responder is Field.Cell.Editor {
            return super.makeFirstResponder(responder)
        }
        return true
    }

    override var canBecomeKey: Bool {
        true
    }
}
