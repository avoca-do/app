import AppKit
import Combine

extension Projects {
    final class Progress: NSPopover {
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            behavior = .transient
            contentSize = .init(width: 300, height: 360)
            contentViewController = .init()
            contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
            contentViewController!.view.wantsLayer = true
            
            let progress = Session.archive.progress(Session.path.board)
            
            let ring = CAShapeLayer()
            ring.frame = .init(x: 20, y: 80, width: 260, height: 260)
            ring.strokeColor = NSColor.controlAccentColor.withAlphaComponent(0.2).cgColor
            ring.fillColor = .clear
            ring.lineWidth = Metrics.progress.stroke
            ring.lineCap = .round
            ring.path = {
                $0.addArc(center: .init(x: 130, y: 130), radius: 130 - Metrics.progress.stroke, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
                return $0
            } (CGMutablePath())
            contentViewController!.view.layer!.addSublayer(ring)
            
            let current = CAShapeLayer()
            current.frame = .init(origin: .zero, size: ring.frame.size)
            current.strokeColor = NSColor.controlAccentColor.cgColor
            current.fillColor = .clear
            current.lineWidth = Metrics.progress.stroke
            current.lineCap = .round
            current.path = {
                $0.addArc(center: .init(x: 130, y: 130), radius: 130 - Metrics.progress.stroke, startAngle: .pi / 2, endAngle: .pi / 2 + (.pi * -2 * .init(progress.percentage)), clockwise: true)
                return $0
            } (CGMutablePath())
            
            let gradient = CAGradientLayer()
            gradient.frame = ring.frame
            gradient.startPoint = .init(x: 0.5, y: 0)
            gradient.endPoint = .init(x: 0.5, y: 1)
            gradient.locations = [0, 1]
            gradient.colors = [NSColor.systemPurple.cgColor, NSColor.controlAccentColor.cgColor]
            gradient.mask = current
            contentViewController!.view.layer!.addSublayer(gradient)
            
            let percent = Text()
            percent.stringValue = Session.percentage.string(from: .init(value: progress.percentage)) ?? ""
            percent.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .bold)
            contentViewController!.view.addSubview(percent)
            
            let cards = Text()
            cards.stringValue = Session.decimal.string(from: .init(value: progress.cards)) ?? ""
            
            let done = Text()
            done.stringValue = Session.decimal.string(from: .init(value: progress.done)) ?? ""
            
            let cardsTitle = Text()
            cardsTitle.stringValue = NSLocalizedString("Cards", comment: "")
            
            let doneTitle = Text()
            doneTitle.stringValue = Session.archive[title: .column(Session.path.board, Session.archive.count(Session.path.board) - 1)]
            doneTitle.lineBreakMode = .byTruncatingTail
            doneTitle.maximumNumberOfLines = 1
            doneTitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            
            [cards, done].forEach {
                $0.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize, weight: .bold)
                contentViewController!.view.addSubview($0)
                
                $0.bottomAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -30).isActive = true
            }
            
            [cardsTitle, doneTitle].forEach {
                $0.font = .preferredFont(forTextStyle: .body)
                contentViewController!.view.addSubview($0)
                
                $0.centerYAnchor.constraint(equalTo: cards.centerYAnchor).isActive = true
            }
            
            percent.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
            percent.centerYAnchor.constraint(equalTo: contentViewController!.view.topAnchor, constant: 150).isActive = true
            
            cards.leftAnchor.constraint(equalTo: contentViewController!.view.leftAnchor, constant: 30).isActive = true
            done.rightAnchor.constraint(equalTo: contentViewController!.view.rightAnchor, constant: -30).isActive = true
            
            cardsTitle.leftAnchor.constraint(equalTo: cards.rightAnchor, constant: 5).isActive = true
            doneTitle.rightAnchor.constraint(equalTo: done.leftAnchor, constant: -5).isActive = true
            doneTitle.leftAnchor.constraint(greaterThanOrEqualTo: cardsTitle.rightAnchor, constant: 10).isActive = true
        }
    }
}
