import AppKit
import Combine

final class Bar: NSView, NSWindowDelegate {
    private weak var backgroundLeft: NSVisualEffectView?
    private weak var backgroundRight: NSVisualEffectView?
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
        self.backgroundLeft = backgroundLeft
        
        let backgroundRight = NSVisualEffectView()
        backgroundRight.translatesAutoresizingMaskIntoConstraints = false
        backgroundRight.state = .active
        backgroundRight.material = .menu
        addSubview(backgroundRight)
        self.backgroundRight = backgroundRight
        
        let activity = Option(icon: "chart.pie")
        activity.toolTip = "General activity"
        activity
            .click
            .sink {
                Activity()
                    .show(relativeTo: activity.bounds, of: activity, preferredEdge: .minY)
            }
            .store(in: &subs)
        
        let find = Option(icon: "magnifyingglass")
        find.toolTip = "Find"
        find
            .click
            .sink {
                NSApp.find(nil)
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
            .sink {
                session.newCard()
            }
            .store(in: &subs)

        let stats = Option(icon: "barometer")
        stats.toolTip = "Stats"
        stats
            .click
            .sink {
                guard case let .view(board) = session.state.value else { return }
                Stats(board: board)
                    .show(relativeTo: stats.bounds, of: stats, preferredEdge: .minY)
            }
            .store(in: &subs)
        
        let wave = Option(icon: "waveform.path.ecg")
        wave.toolTip = "Project activity"
        wave
            .click
            .sink {
                guard case let .view(board) = session.state.value else { return }
                Wave(board: board)
                    .show(relativeTo: wave.bounds, of: wave, preferredEdge: .minY)
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
        
        [activity, find, plus]
            .forEach {
                backgroundLeft.addSubview($0)
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
        
        [card, title, cancel, add, save, delete, stats, edit, wave]
            .forEach {
                backgroundRight.addSubview($0)
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
        
        var left = safeAreaLayoutGuide.leftAnchor
        [activity, find, plus]
            .forEach {
                $0.leftAnchor.constraint(equalTo: left, constant: left == safeAreaLayoutGuide.leftAnchor ? 60 : 10).isActive = true
                left = $0.rightAnchor
            }
        
        var right = rightAnchor
        [card, stats, wave, edit]
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
                case .none, .empty:
                    title.attributedStringValue = .init()
                    delete.state = .hidden
                    cancel.state = .hidden
                    add.state = .hidden
                    save.state = .hidden
                    card.state = .hidden
                    stats.state = .hidden
                    wave.state = .hidden
                    edit.state = .hidden
                case .create:
                    delete.state = .hidden
                    cancel.state = .on
                    add.state = .on
                    save.state = .hidden
                    card.state = .hidden
                    stats.state = .hidden
                    wave.state = .hidden
                    edit.state = .hidden
                    
                    title.attributedStringValue = .make("New project",
                                                        font: .font(style: .callout, weight: .light),
                                                        color: .secondaryLabelColor)
                case .view:
                    title.attributedStringValue = .init()
                    delete.state = .hidden
                    cancel.state = .hidden
                    add.state = .hidden
                    save.state = .hidden
                    card.state = .on
                    stats.state = .on
                    wave.state = .on
                    edit.state = .on
                case let .column(board):
                    delete.state = .hidden
                    cancel.state = .on
                    add.state = .on
                    save.state = .hidden
                    card.state = .hidden
                    stats.state = .hidden
                    wave.state = .hidden
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
                    wave.state = .hidden
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
                    wave.state = .hidden
                    edit.state = .hidden
                    
                    switch path {
                    case .card:
                        title.attributedStringValue = .make {
                            $0.append(.make(cloud.archive.value[path.board].name + " : " + cloud.archive.value[path.board][path.column].name + " : ",
                                            font: .font(style: .callout, weight: .light),
                                            color: .tertiaryLabelColor,
                                            lineBreak: .byTruncatingMiddle))
                            $0.append(.make("Update card",
                                            font: .font(style: .callout, weight: .light),
                                            color: .secondaryLabelColor))
                        }
                    case .column:
                        title.attributedStringValue = .make {
                            $0.append(.make(cloud.archive.value[path.board].name + " : ",
                                            font: .font(style: .callout, weight: .light),
                                            color: .tertiaryLabelColor,
                                            lineBreak: .byTruncatingMiddle))
                            $0.append(.make("Rename column",
                                            font: .font(style: .callout, weight: .light),
                                            color: .secondaryLabelColor))
                        }
                    case .board:
                        title.attributedStringValue = .make("Rename project",
                                                            font: .font(style: .callout, weight: .light),
                                                            color: .secondaryLabelColor)
                    }
                }
            }
            .store(in: &subs)
    }
    
    func windowWillEnterFullScreen(_: Notification) {
        backgroundLeft?.material = .sheet
        backgroundRight?.material = .sheet
        backgroundLeft?.state = .inactive
        backgroundRight?.state = .inactive
    }
    
    func windowWillExitFullScreen(_: Notification) {
        backgroundLeft?.material = .popover
        backgroundRight?.material = .menu
        backgroundLeft?.state = .active
        backgroundRight?.state = .active
    }
}
