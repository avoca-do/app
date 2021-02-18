import AppKit

extension Projects {
    final class Empty: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            let text = Text()
            text.stringValue = NSLocalizedString("Click +\nto start a project", comment: "")
            text.font = .preferredFont(forTextStyle: .title3)
            text.textColor = .secondaryLabelColor
            addSubview(text)
            
            text.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            text.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 50).isActive = true
        }
    }
}
