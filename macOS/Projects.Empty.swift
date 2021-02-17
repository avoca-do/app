import AppKit

extension Projects {
    final class Empty: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
        }
    }
}
