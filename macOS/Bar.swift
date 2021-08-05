import AppKit
import Combine

final class Bar: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let activity = Option(icon: "chart.pie")
        activity.toolTip = "Activity"
        activity
            .click
            .sink {
//                NSApp.activity()
            }
            .store(in: &subs)
        
        let search = Option(icon: "magnifyingglass")
        search.toolTip = "Search"
        search
            .click
            .sink {
//                NSApp.activity()
            }
            .store(in: &subs)
        
        let plus = Option(icon: "plus", size: 16)
        plus.toolTip = "New project"
        plus
            .click
            .map {
                .create
            }
            .subscribe(session.state)
            .store(in: &subs)
        
        let title = Text()
        title.maximumNumberOfLines = 1
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let cancel = Action(title: "CANCEL", color: .systemPink)
        cancel
            .click
            .sink {
                self.window?.cancelOperation(nil)
            }
            .store(in: &subs)
        
        let create = Action(title: "CREATE", color: .systemBlue)
        let save = Action(title: "SAVE", color: .systemBlue)
        
        [activity, search, plus, title, cancel, create, save]
            .forEach {
                addSubview($0)
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
        
        var left = safeAreaLayoutGuide.leftAnchor
        [activity, search, plus]
            .forEach {
                $0.leftAnchor.constraint(equalTo: left, constant: left == safeAreaLayoutGuide.leftAnchor ? 60 : 10).isActive = true
                left = $0.rightAnchor
            }
        
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 200).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: cancel.leftAnchor, constant: -10).isActive = true
        
        create.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        save.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        cancel.rightAnchor.constraint(equalTo: create.leftAnchor, constant: -10).isActive = true
        
        session
            .state
            .removeDuplicates()
            .sink {
                switch $0 {
                case .none:
                    title.attributedStringValue = .init()
                    cancel.state = .hidden
                    create.state = .hidden
                    save.state = .hidden
                case .create:
                    title.attributedStringValue = .init()
                    cancel.state = .hidden
                    create.state = .hidden
                    save.state = .hidden
                case let .view(board):
                    title.attributedStringValue = .init()
                    cancel.state = .hidden
                    create.state = .hidden
                    save.state = .hidden
                case let .new(path):
                    title.attributedStringValue = .init()
                    cancel.state = .hidden
                    create.state = .hidden
                    save.state = .hidden
                case let .edit(path):
                    cancel.state = .on
                    create.state = .hidden
                    save.state = .on
                    switch path {
                    case .card:
                        title.attributedStringValue = .make {
                            $0.append(.make(cloud.archive.value[path.board].name + " : " + cloud.archive.value[path.board][path.column].name + " : ",
                                            font: .font(style: .callout, weight: .light),
                                            color: .secondaryLabelColor,
                                            lineBreak: .byTruncatingMiddle))
                            $0.append(.make("Edit card",
                                            font: .font(style: .callout, weight: .regular),
                                            color: .labelColor))
                        }
                    default:
                        break
                    }
                }
            }
            .store(in: &subs)
    }
}
