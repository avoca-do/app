import AppKit
import Kanban

final class Capacity: NSView {
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let title = Text()
        title.stringValue = NSLocalizedString("You can purchase more capacity.\nYou could also delete any existing project to free up capacity.", comment: "")
        title.font = .preferredFont(forTextStyle: .body)
        title.textColor = .secondaryLabelColor
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        
        title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -30).isActive = true
    }
}
