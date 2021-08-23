import AppKit
import Combine

final class Stats: NSPopover {
    required init?(coder: NSCoder) { nil }
    init(board: Int) {
        super.init()
        behavior = .semitransient
        contentSize = .init(width: 300, height: 390)
        contentViewController = .init()
        contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
        view.wantsLayer = true
        
        let progress = cloud.archive.value[board].progress
        
        let ring = Shape()
        ring.frame = .init(x: 30, y: 40, width: 240, height: 240)
        ring.strokeColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
        ring.fillColor = .clear
        ring.lineWidth = 10
        ring.path = {
            $0.addArc(center: .init(x: 120, y: 120), radius: 115, startAngle: 0, endAngle: 2 * .pi, clockwise: false)
            return $0
        } (CGMutablePath())
        view.layer!.addSublayer(ring)
        
        let current = Shape()
        current.frame = .init(origin: .zero, size: ring.frame.size)
        current.strokeColor = .white
        current.fillColor = .clear
        current.lineWidth = 10
        current.lineCap = .round
        current.path = {
            $0.addArc(center: .init(x: 120, y: 120), radius: 115, startAngle: .pi / 2, endAngle: .pi / 2 + (.pi * -2 * .init(progress.percentage)), clockwise: true)
            return $0
        } (CGMutablePath())
        
        current.add({
            $0.duration = 2
            $0.fromValue = 0
            $0.toValue = 1
            $0.timingFunction = .init(name: .easeInEaseOut)
            return $0
        } (CABasicAnimation(keyPath: "strokeEnd")), forKey: "strokeEnd")
        
        let gradient = Gradient()
        gradient.frame = ring.frame
        gradient.startPoint = .init(x: 0.5, y: 0)
        gradient.endPoint = .init(x: 0.5, y: 1)
        gradient.locations = [0, 1]
        gradient.colors = [NSColor.controlAccentColor.cgColor, NSColor.quaternaryLabelColor.cgColor]
        gradient.mask = current
        contentViewController!.view.layer!.addSublayer(gradient)
        
        let columns = counter(title: "Columns", value: cloud.archive.value[board].count)
        let cards = counter(title: "Cards", value: progress.cards)
        let completed = counter(title: "Done", value: progress.done)
        
        let percent = Text(vibrancy: true)
        percent.font = .monoDigit(style: .largeTitle, weight: .light)
        percent.textColor = .labelColor
        view.addSubview(percent)
        
        var right = view.rightAnchor
        [completed, cards, columns]
            .forEach {
                view.addSubview($0)
                $0.rightAnchor.constraint(equalTo: right, constant: -35).isActive = true
                right = $0.leftAnchor
            }
        
        columns.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        cards.topAnchor.constraint(equalTo: columns.topAnchor).isActive = true
        completed.topAnchor.constraint(equalTo: columns.topAnchor).isActive = true
        percent.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -160).isActive = true
        percent.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
        var counter = Double()
        var sub: AnyCancellable?
        sub = timer.sink { _ in
            if counter < progress.percentage {
                counter += progress.percentage / 75
            } else {
                timer.upstream.connect().cancel()
                sub?.cancel()
                counter = progress.percentage
            }
            percent.stringValue = NumberFormatter.percent.string(from: .init(value: counter)) ?? ""
        }
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
