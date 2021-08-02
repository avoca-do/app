import AppKit

final class Content: NSVisualEffectView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        state = .active
        material = .menu
    }
}
