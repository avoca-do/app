import AppKit
import Combine

final class Field: NSTextField, NSTextFieldDelegate {
    let finish = PassthroughSubject<Void, Never>()
    private let write: Write
    
    override var canBecomeKeyView: Bool { true }
    
    required init?(coder: NSCoder) { nil }
    init(write: Write) {
        self.write = write
        super.init(frame: .zero)
        bezelStyle = .roundedBezel
        translatesAutoresizingMaskIntoConstraints = false
        font = .preferredFont(forTextStyle: .title3)
        controlSize = .large
        delegate = self
        lineBreakMode = .byTruncatingHead
        target = self
        action = #selector(done)
        textColor = .labelColor
        isAutomaticTextCompletionEnabled = false
        
        switch write {
        case let .new(path):
            switch path {
            case .archive:
                placeholderString = NSLocalizedString("Kanban Board", comment: "")
            case .board:
                placeholderString = NSLocalizedString("NEW COLUMN", comment: "")
            default: break
            }
        case let .edit(path):
            switch path {
            case .board:
                stringValue = Session.shared.archive.value[name: path]
            case .column:
                stringValue = Session.shared.archive.value[title: path]
            default: break
            }
            placeholderString = stringValue
        }
    }
    
    @objc func done() {
        let text = stringValue.isEmpty ? placeholderString! : stringValue
        
        switch write {
        case let .new(path):
            switch path {
            case .archive:
                Session.shared.archive.value.add()
                Session.shared.archive.value[name: .board(0)] = text
                Session.shared.path.value = .board(0)
            case .board:
                Session.shared.archive.value.column(path)
                Session.shared.archive.value[title: .column(path, Session.shared.archive.value.count(path) - 1)] = text
            default: break
            }
        case let .edit(path):
            switch path {
            case .board:
                Session.shared.archive.value[name: path] = text
            case .column:
                Session.shared.archive.value[title: path] = text
            default: break
            }
        }
        
        finish.send()
    }
}
