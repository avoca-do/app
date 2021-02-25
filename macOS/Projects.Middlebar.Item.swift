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
            wantsLayer = true
            layer!.cornerRadius = 8
            translatesAutoresizingMaskIntoConstraints = false
            
            let text = Text()
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 16).isActive = true
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -16).isActive = true
            
            Session.archiving.removeDuplicates {
                $0[name: path] == $1[name: path] && $0.date(path.board) == $1.date(path.board)
            }
            .sink {
                text.attributedStringValue = .make(
                    [.init(string: $0[name: path] + "\n", attributes: [
                            .font: NSFont.boldSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize)]),
                     .init(string: RelativeDateTimeFormatter().string(from: $0.date(path), to: .init()), attributes: [
                            .font: NSFont.preferredFont(forTextStyle: .callout),
                            .foregroundColor: NSColor.secondaryLabelColor])])
            }.store(in: &subs)
            
            click.sink { [weak self] in
                guard let path = self?.path else { return }
                Session.edit.send(nil)
                Session.path = path
            }.store(in: &subs)
        }
        
        override func update() {
            super.update()
            
            switch state {
            case .selected:
                layer!.backgroundColor = NSColor.controlAccentColor.withAlphaComponent(0.2).cgColor
            case .highlighted:
                layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
            default:
                layer!.backgroundColor = .clear
            }
        }
    }
}
