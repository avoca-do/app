import AppKit
import Combine
import Kanban

extension Projects.Middlebar {
    final class Item: Control {
        let path: Path
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(path: Path) {
            self.path = path
            super.init()
            translatesAutoresizingMaskIntoConstraints = false
            
            let text = Text()
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 16).isActive = true
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -16).isActive = true
            
            Session.shared.archive.removeDuplicates {
                $0[name: path] == $1[name: path]
            }.sink {
                text.attributedStringValue = .make(
                    [.init(string: $0[name: path] + "\n", attributes: [
                            .font: NSFont.boldSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize)]),
                     .init(string: RelativeDateTimeFormatter().localizedString(for: $0.date(path), relativeTo: .init()), attributes: [
                            .font: NSFont.preferredFont(forTextStyle: .footnote),
                            .foregroundColor: NSColor.secondaryLabelColor])])
            }.store(in: &subs)
            
            click.sink { [weak self] in
                guard let path = self?.path else { return }
                Session.shared.path.value = path
            }.store(in: &subs)
        }
        
        override func update() {
            switch state {
            case .selected:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.15).cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
    }
}
