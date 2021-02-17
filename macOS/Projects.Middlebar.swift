import AppKit

extension Projects {
    final class Middlebar: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            wantsLayer = true
            layer!.backgroundColor = .init(gray: 0, alpha: 0.1)
            layer!.borderWidth = 2
            layer!.borderColor = .init(gray: 0, alpha: 0.3)
            
            let titlebar = Titlebar()
            addSubview(titlebar)
            
            widthAnchor.constraint(equalToConstant: Metrics.sidebar.width).isActive = true
            
            titlebar.topAnchor.constraint(equalTo: topAnchor).isActive = true
            titlebar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            titlebar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            titlebar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        }
    }
}
