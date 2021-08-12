import AppKit

final class Stats: NSPopover {
    required init?(coder: NSCoder) { nil }
    init(board: Int) {
        super.init()
        behavior = .semitransient
        contentSize = .init(width: 400, height: 400)
        contentViewController = .init()
        contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
        
        let progress = cloud.archive.value[board].progress
        let columns = counter(title: "Columns", value: cloud.archive.value[board].count)
        let cards = counter(title: "Cards", value: progress.cards)
        let completed = counter(title: "Done", value: progress.done)
        
        let percent = Text(vibrancy: true)
        percent.stringValue = NumberFormatter.percent.string(from: .init(value: progress.percentage)) ?? ""
        percent.font = .monoDigit(style: .largeTitle, weight: .light)
        percent.textColor = .labelColor
        view.addSubview(percent)
        
        var left = view.leftAnchor
        [columns, cards, completed]
            .forEach {
                view.addSubview($0)
                $0.leftAnchor.constraint(equalTo: left, constant: 30).isActive = true
                left = $0.rightAnchor
            }
        
        columns.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        cards.topAnchor.constraint(equalTo: columns.topAnchor).isActive = true
        completed.topAnchor.constraint(equalTo: columns.topAnchor).isActive = true
        percent.centerYAnchor.constraint(equalTo: completed.centerYAnchor).isActive = true
        percent.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
    }
    
    private func counter(title: String, value: Int) -> Text {
        let text = Text(vibrancy: true)
        text.attributedStringValue = .make {
            $0.append(.make(NumberFormatter
                                .decimal
                                .string(from: .init(value: value)) ?? "",
                            font: .monoDigit(style: .title1, weight: .light),
                            color: .secondaryLabelColor,
                            alignment: .right))
            $0.linebreak()
            $0.append(.make(title, font: .preferredFont(forTextStyle: .body),
                            color: .tertiaryLabelColor,
                            alignment: .right))
        }
        return text
    }
}
