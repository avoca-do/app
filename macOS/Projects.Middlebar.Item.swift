import AppKit
import Kanban

extension Projects.Middlebar {
    final class Item: Control {
        let path: Path
        
        required init?(coder: NSCoder) { nil }
        init(path: Path, name: String, date: String) {
            self.path = path
            super.init()
            translatesAutoresizingMaskIntoConstraints = false
            
            let text = Text()
            text.font = .boldSystemFont(ofSize: NSFont.preferredFont(forTextStyle: .body).pointSize)
            text.stringValue = name
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(text)
            
            bottomAnchor.constraint(equalTo: text.bottomAnchor, constant: 10).isActive = true
            
            text.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            text.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
            text.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -10).isActive = true
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
