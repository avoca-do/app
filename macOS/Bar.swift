import AppKit
import Combine

final class Bar: NSView {
    private var subs = Set<AnyCancellable>()
    private var leftWidth: NSLayoutConstraint?
    
    override func viewDidMoveToWindow() {
        window
            .map {
                $0.contentView
                    .map {
                        leftWidth!.constant = convert(.init(x: Sidebar.width, y: 0), from: $0).x - 1
                    }
            }
    }
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let backgroundLeft = NSVisualEffectView()
        backgroundLeft.translatesAutoresizingMaskIntoConstraints = false
        backgroundLeft.state = .active
        backgroundLeft.material = .popover
        addSubview(backgroundLeft)
        
        let backgroundRight = NSVisualEffectView()
        backgroundRight.translatesAutoresizingMaskIntoConstraints = false
        backgroundRight.state = .active
        backgroundRight.material = .menu
        addSubview(backgroundRight)
        
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
        
        let plus = Option(icon: "plus", size: 15)
        plus.toolTip = "New project"
        plus
            .click
            .sink {
                session.newProject()
            }
            .store(in: &subs)
        
        let card = Option(icon: "plus", size: 15)
        card.toolTip = "New card"
        card
            .click
            .compactMap {
                guard case let .view(board) = session.state.value else { return nil }
                return .card(board)
            }
            .subscribe(session.state)
            .store(in: &subs)
        
        let stats = Option(icon: "barometer")
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
        
        let title = Text(vibrancy: true)
        title.maximumNumberOfLines = 1
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let cancel = Action(title: "CANCEL", color: .systemPink, foreground: .white)
        cancel
            .click
            .sink {
                session.cancel()
            }
            .store(in: &subs)
        
        let add = Action(title: "ADD", color: .systemBlue, foreground: .white)
        add
            .click
            .sink {
                session.add()
            }
            .store(in: &subs)
        
        let save = Action(title: "SAVE", color: .systemBlue, foreground: .white)
        save
            .click
            .sink {
                session.save()
            }
            .store(in: &subs)
        
        let delete = Action(title: "DELETE", color: .labelColor, foreground: .windowBackgroundColor)
        delete
            .click
            .sink {
                if case let .edit(path) = session.state.value {
                    NSAlert.delete(path: path)
                }
            }
            .store(in: &subs)
        
        backgroundLeft.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backgroundLeft.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundLeft.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        leftWidth = backgroundLeft.widthAnchor.constraint(equalToConstant: 0)
        leftWidth!.isActive = true
        
        backgroundRight.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        backgroundRight.leftAnchor.constraint(equalTo: backgroundLeft.rightAnchor, constant: 1).isActive = true
        backgroundRight.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundRight.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        [activity, search, plus]
            .forEach {
                backgroundLeft.addSubview($0)
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
        
        [card, title, cancel, add, save, delete, stats, edit]
            .forEach {
                backgroundRight.addSubview($0)
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
                                                        font: .font(style: .callout, weight: .light),
                                                        color: .secondaryLabelColor)
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
                                        color: .tertiaryLabelColor,
                                        lineBreak: .byTruncatingMiddle))
                        $0.append(.make("New column",
                                        font: .font(style: .callout, weight: .light),
                                        color: .secondaryLabelColor))
                    }
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
                                        color: .tertiaryLabelColor,
                                        lineBreak: .byTruncatingMiddle))
                        $0.append(.make("New card",
                                        font: .font(style: .callout, weight: .light),
                                        color: .secondaryLabelColor))
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
                                            color: .tertiaryLabelColor,
                                            lineBreak: .byTruncatingMiddle))
                            $0.append(.make("Edit card",
                                            font: .font(style: .callout, weight: .light),
                                            color: .secondaryLabelColor))
                        }
                    case .column:
                        title.attributedStringValue = .make {
                            $0.append(.make(cloud.archive.value[path.board].name + " : ",
                                            font: .font(style: .callout, weight: .light),
                                            color: .tertiaryLabelColor,
                                            lineBreak: .byTruncatingMiddle))
                            $0.append(.make("Edit column",
                                            font: .font(style: .callout, weight: .light),
                                            color: .secondaryLabelColor))
                        }
                    case .board:
                        title.attributedStringValue = .make("Edit board",
                                                            font: .font(style: .callout, weight: .light),
                                                            color: .secondaryLabelColor)
                    }
                }
            }
            .store(in: &subs)
    }
}
