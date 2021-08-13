import AppKit

extension Find {
    final class Content: NSVisualEffectView {
        required init?(coder: NSCoder) { nil }
        override init(frame: CGRect) {
            super.init(frame: frame)
            material = .hudWindow
            state = .active
            wantsLayer = true
            layer!.cornerRadius = 20
            addTrackingArea(.init(rect: .zero, options: [.mouseEnteredAndExited, .mouseMoved, .activeInActiveApp, .inVisibleRect], owner: self))
        }
    }
}
