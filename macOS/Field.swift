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
                stringValue = Session.archive[name: path]
            case .column:
                stringValue = Session.archive[title: path]
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
                Session.mutate {
                    $0.add()
                    $0[name: .board(0)] = text
                }
                Session.path = .board(0)
                Session.scroll.send()
            case .board:
                Session.mutate {
                    $0.column(path)
                    $0[title: .column(path, $0.count(path) - 1)] = text
                }
            default: break
            }
        case let .edit(path):
            switch path {
            case .board:
                Session.mutate {
                    $0[name: path] = text
                }
            case .column:
                Session.mutate {
                    $0[title: path] = text
                }
            default: break
            }
        }
        
        finish.send()
    }
}
