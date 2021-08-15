import AppKit
import Combine
import Kanban

extension Find {
    final class Content: NSView, NSTextFieldDelegate {        
        private weak var xmark: Option!
        private weak var field: Field!
        private weak var icon: Image!
        private var subs = Set<AnyCancellable>()
        private let found = PassthroughSubject<[Found], Never>()
        private let move = PassthroughSubject<(date: Date, direction: Move), Never>()
        
        override var allowsVibrancy: Bool {
            true
        }
        
        required init?(coder: NSCoder) { nil }
        override init(frame: NSRect) {
            super.init(frame: frame)
            
            let magnifier = Image(icon: "magnifyingglass")
            magnifier.symbolConfiguration = .init(pointSize: 16, weight: .regular)
            magnifier.contentTintColor = .tertiaryLabelColor
            addSubview(magnifier)
            
            let field = Field()
            field.delegate = self
            addSubview(field)
            self.field = field
            
            let separator = Separator(mode: .horizontal)
            addSubview(separator)
            
            let xmark = Option(icon: "xmark.circle.fill")
            xmark.state = .off
            xmark
                .click
                .sink { [weak self] in
                    field.stringValue = ""
                    self?.update()
                }
                .store(in: &subs)
            addSubview(xmark)
            self.xmark = xmark
            
            let icon = Image(icon: "magnifyingglass")
            icon.symbolConfiguration = .init(pointSize: 35, weight: .regular)
            icon.contentTintColor = .quaternaryLabelColor
            addSubview(icon)
            self.icon = icon
            
            let results = Results(found: found, move: move)
            addSubview(results)
            
            magnifier.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
            magnifier.leftAnchor.constraint(equalTo: leftAnchor, constant: 18).isActive = true
            
            xmark.centerYAnchor.constraint(equalTo: field.centerYAnchor).isActive = true
            xmark.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
            
            field.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            field.leftAnchor.constraint(equalTo: magnifier.rightAnchor).isActive = true
            field.rightAnchor.constraint(equalTo: xmark.leftAnchor).isActive = true
            
            separator.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 8).isActive = true
            separator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            separator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            
            results.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
            results.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            results.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            results.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            icon.centerYAnchor.constraint(equalTo: results.centerYAnchor).isActive = true
            icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        func controlTextDidChange(_: Notification) {
            update()
        }
        
        func control(_: NSControl, textView: NSTextView, doCommandBy: Selector) -> Bool {
            switch doCommandBy {
            case #selector(cancelOperation), #selector(complete), #selector(NSSavePanel.cancel):
                window?.close()
            case #selector(moveUp):
                move.send((date: .init(), direction: .up))
            case #selector(moveDown):
                move.send((date: .init(), direction: .down))
            default:
                return false
            }
            return true
        }
        
        private func update() {
            xmark.state = field.stringValue.isEmpty ? .off : .on
            cloud
                .find(search: field.stringValue) { [weak self] in
                    self?.icon.isHidden = !$0.isEmpty
                    self?.found.send($0)
                }
        }
    }
}
