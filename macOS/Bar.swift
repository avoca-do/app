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
        
        let card = Option(icon: "plus", size: 16)
        card.toolTip = "New card"
        card
            .click
            .compactMap {
                guard case let .view(board) = session.state.value else { return nil }
                return .card(board)
            }
            .subscribe(session.state)
            .store(in: &subs)
        
        let stats = Option(icon: "gauge")
        stats.toolTip = "Stats"
        stats
            .click
            .sink {
                
            }
            .store(in: &subs)
        
        let edit = Option(icon: "slider.horizontal.3")
        edit.toolTip = "Edit"
        edit
            .click
            .compactMap {
                guard case let .view(board) = session.state.value else { return nil }
                return .edit(.board(board))
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
                session.cancel()
            }
            .store(in: &subs)
        
        let add = Action(title: "ADD", color: .systemBlue)
        let save = Action(title: "SAVE", color: .systemBlue)
        
        let delete = Action(title: "DELETE", color: .black)
        delete
            .click
            .sink {
                if case let .edit(path) = session.state.value {
                    NSAlert.delete(path: path)
                }
            }
            .store(in: &subs)
        
        [activity, search, plus, card, title, cancel, add, save, delete, stats, edit]
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
        
        var right = rightAnchor
        [card, stats, edit]
            .forEach {
                $0.rightAnchor.constraint(equalTo: right, constant: right == rightAnchor ? -8 : -10).isActive = true
                right = $0.leftAnchor
            }
        
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 225).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: delete.leftAnchor, constant: -10).isActive = true
        
        add.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        save.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        cancel.rightAnchor.constraint(equalTo: add.leftAnchor, constant: -10).isActive = true
        delete.rightAnchor.constraint(equalTo: cancel.leftAnchor, constant: -10).isActive = true
        
        session
            .state
            .removeDuplicates()
            .sink {
                switch $0 {
                case .none:
                    title.attributedStringValue = .init()
                    delete.state = .hidden
                    cancel.state = .hidden
                    add.state = .hidden
                    save.state = .hidden
                    card.state = .hidden
                    stats.state = .hidden
                    edit.state = .hidden
                case .create:
                    delete.state = .hidden
                    cancel.state = .on
                    add.state = .on
                    save.state = .hidden
                    card.state = .hidden
                    stats.state = .hidden
                    edit.state = .hidden
                    
                    title.attributedStringValue = .make("New project",
                                                        font: .font(style: .callout, weight: .regular),
                                                        color: .labelColor)
                case let .view(board):
                    title.attributedStringValue = .init()
                    delete.state = .hidden
                    cancel.state = .hidden
                    add.state = .hidden
                    save.state = .hidden
                    card.state = .on
                    stats.state = .on
                    edit.state = .on
                case let .column(board):
                    title.attributedStringValue = .init()
                    delete.state = .hidden
                    cancel.state = .hidden
                    add.state = .hidden
                    save.state = .hidden
                    card.state = .hidden
                    stats.state = .hidden
                    edit.state = .hidden
                case let .card(board):
                    delete.state = .hidden
                    cancel.state = .on
                    add.state = .on
                    save.state = .hidden
                    card.state = .hidden
                    stats.state = .hidden
                    edit.state = .hidden
                    
                    title.attributedStringValue = .make {
                        $0.append(.make(cloud.archive.value[board].name + " : ",
                                        font: .font(style: .callout, weight: .light),
                                        color: .secondaryLabelColor,
                                        lineBreak: .byTruncatingMiddle))
                        $0.append(.make("New card",
                                        font: .font(style: .callout, weight: .regular),
                                        color: .labelColor))
                    }
                case let .edit(path):
                    delete.state = .on
                    cancel.state = .on
                    add.state = .hidden
                    save.state = .on
                    card.state = .hidden
                    stats.state = .hidden
                    edit.state = .hidden
                    
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
                    case .column:
                        title.attributedStringValue = .make {
                            $0.append(.make(cloud.archive.value[path.board].name + " : ",
                                            font: .font(style: .callout, weight: .light),
                                            color: .secondaryLabelColor,
                                            lineBreak: .byTruncatingMiddle))
                            $0.append(.make("Edit column",
                                            font: .font(style: .callout, weight: .regular),
                                            color: .labelColor))
                        }
                    case .board:
                        title.attributedStringValue = .make("Edit board",
                                                            font: .font(style: .callout, weight: .regular),
                                                            color: .labelColor)
                    }
                }
            }
            .store(in: &subs)
    }
}
