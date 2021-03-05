import AppKit
import Combine
import Kanban

final class Plus: NSPopover {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(write: Write) {
        super.init()
        behavior = .transient
        contentSize = .init(width: 240, height: 180)
        contentViewController = .init()
        contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
        
        let _title: String
        let _button: String
        
        switch write {
        case let .new(path):
            switch path {
            case .archive:
                _title = NSLocalizedString("New project", comment: "")
                _button = NSLocalizedString("Start", comment: "")
            default:
                _title = NSLocalizedString("New column", comment: "")
                _button = NSLocalizedString("Add", comment: "")
            }
        case let .edit(path):
            switch path {
            case .archive:
                _title = NSLocalizedString("Rename project", comment: "")
                _button = NSLocalizedString("Save", comment: "")
            default:
                _title = NSLocalizedString("Rename column", comment: "")
                _button = NSLocalizedString("Save", comment: "")
            }
        }
        
        let title = Text()
        title.stringValue = _title
        title.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title3).pointSize, weight: .bold)
        
        let field = Field(write: write)
        field.finish.sink { [weak self] in
            self?.close()
        }.store(in: &subs)
        
        let button = Control.Rectangle(title: _button)
        button.layer!.backgroundColor = NSColor.controlAccentColor.cgColor
        button.text.textColor = .black
        button.click.sink {
            field.done()
        }.store(in: &subs)
        
        [title, field, button].forEach {
            contentViewController!.view.addSubview($0)
            
            $0.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 20).isActive = true
            $0.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor, constant: -20).isActive = true
        }
        
        title.topAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 20).isActive = true
        field.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
        button.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -20).isActive = true
    }
}
