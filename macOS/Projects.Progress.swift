import AppKit
import Combine

extension Projects {
    final class Progress: NSPopover {
        required init?(coder: NSCoder) { nil }
        override init() {
            super.init()
            behavior = .transient
            contentSize = .init(width: 320, height: 400)
            contentViewController = .init()
            contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
            contentViewController!.view.wantsLayer = true
            
            let progress = Session.archive.progress(Session.path.board)
            
            let ring = CAShapeLayer()
            ring.frame = .init(x: 40, y: 120, width: 240, height: 240)
            ring.strokeColor = NSColor.controlAccentColor.withAlphaComponent(Metrics.accent.low).cgColor
            ring.fillColor = .clear
            ring.lineWidth = Metrics.progress.stroke
            ring.lineCap = .round
            ring.path = {
                $0.addArc(center: .init(x: 120, y: 120), radius: 120 - Metrics.progress.stroke, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
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
                $0.addArc(center: .init(x: 120, y: 120), radius: 120 - Metrics.progress.stroke, startAngle: .pi / 2, endAngle: .pi / 2 + (.pi * -2 * .init(progress.percentage)), clockwise: true)
                return $0
            } (CGMutablePath())
            
            current.add({
                $0.duration = 1.5
                $0.fromValue = 0
                $0.toValue = 1
                $0.timingFunction = .init(name: .easeInEaseOut)
                return $0
            } (CABasicAnimation(keyPath: "strokeEnd")), forKey: "strokeEnd")
            
            let gradient = CAGradientLayer()
            gradient.frame = ring.frame
            gradient.startPoint = .init(x: 0.5, y: 0)
            gradient.endPoint = .init(x: 0.5, y: 1)
            gradient.locations = [0, 1]
            gradient.colors = [NSColor.systemPurple.cgColor, NSColor.controlAccentColor.cgColor]
            gradient.mask = current
            contentViewController!.view.layer!.addSublayer(gradient)
            
            let percent = Text()
            percent.font = .systemFont(ofSize: NSFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .bold)
            contentViewController!.view.addSubview(percent)
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            
            let cards = Text()
            cards.attributedStringValue = .make(
                [.init(string: Session.decimal.string(from: .init(value: progress.cards)) ?? "", attributes: [
                        .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize, weight: .bold),
                        .paragraphStyle: paragraph]),
                 .init(string: NSLocalizedString("\nCards", comment: ""), attributes: [
                        .font: NSFont.preferredFont(forTextStyle: .body),
                        .foregroundColor: NSColor.secondaryLabelColor,
                        .paragraphStyle: paragraph])])
            
            let done = Text()
            done.attributedStringValue = .make(
                [.init(string: Session.decimal.string(from: .init(value: progress.done)) ?? "", attributes: [
                        .font: NSFont.systemFont(ofSize: NSFont.preferredFont(forTextStyle: .title1).pointSize, weight: .bold),
                        .paragraphStyle: paragraph]),
                 .init(string: "\n" + Session.archive[title: .column(Session.path.board, Session.archive.count(Session.path.board) - 1)], attributes: [
                        .font: NSFont.preferredFont(forTextStyle: .body),
                        .foregroundColor: NSColor.secondaryLabelColor,
                        .paragraphStyle: paragraph])])
            
            [cards, done].forEach {
                $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                contentViewController!.view.addSubview($0)
                
                $0.topAnchor.constraint(equalTo: percent.bottomAnchor, constant: 140).isActive = true
                $0.widthAnchor.constraint(lessThanOrEqualToConstant: 90).isActive = true
            }
            
            percent.centerXAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor).isActive = true
            percent.centerYAnchor.constraint(equalTo: contentViewController!.view.bottomAnchor, constant: -240).isActive = true
            
            cards.rightAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor, constant: -30).isActive = true
            done.leftAnchor.constraint(equalTo: contentViewController!.view.centerXAnchor, constant: 30).isActive = true
            
            let timer = Timer.publish(every: 0.04, on: .main, in: .common).autoconnect()
            var counter = Double()
            var sub: AnyCancellable?
            sub = timer.sink { _ in
                if counter < progress.percentage {
                    counter += progress.percentage / 37
                } else {
                    timer.upstream.connect().cancel()
                    sub?.cancel()
                    counter = progress.percentage
                }
                percent.stringValue = Session.percentage.string(from: .init(value: counter)) ?? ""
            }
        }
    }
}
