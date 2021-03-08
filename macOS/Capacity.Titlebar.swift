import AppKit
import Combine
import Kanban

extension Capacity {
    final class Titlebar: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            Session.purchases.plusOne.delay(for: .seconds(1), scheduler: DispatchQueue.main).sink { [weak self] in
                self?.refresh()
            }.store(in: &subs)
            refresh()
        }
        
        private func refresh() {
            subviews.forEach { $0.removeFromSuperview() }
            
            let bar = NSView()
            bar.translatesAutoresizingMaskIntoConstraints = false
            bar.wantsLayer = true
            
            let count = Text()
            count.attributedStringValue = .make(
                [.init(string: Session.decimal.string(from: .init(value: Session.archive.count(.archive)))!,
                       attributes: [.foregroundColor: NSColor.labelColor,
                                    .font: NSFont.systemFont(ofSize: 16, weight: .regular)]),
                 .init(string: " / ",
                        attributes: [.foregroundColor: NSColor.labelColor,
                                     .font: NSFont.systemFont(ofSize: 16, weight: .regular)]),
                 .init(string: Session.decimal.string(from: .init(value: Session.archive.capacity))!,
                        attributes: [.foregroundColor: NSColor.tertiaryLabelColor,
                                     .font: NSFont.systemFont(ofSize: 16, weight: .regular)])])
            count.textColor = .labelColor
            count.font = .systemFont(ofSize: 16, weight: .bold)
            
            let total = CAShapeLayer()
            total.frame = .init(x: 20, y: 0, width: 200, height: 10)
            total.strokeColor = NSColor.labelColor.withAlphaComponent(App.dark ? 0.2 : 0.1).cgColor
            total.fillColor = .clear
            total.lineWidth = Metrics.capacity.height
            total.lineCap = .round
            total.path = {
                $0.move(to: .init(x: 0, y: 5))
                $0.addLine(to: .init(x: 200, y: 5))
                return $0
            } (CGMutablePath())
            bar.layer!.addSublayer(total)
            
            let used = CAShapeLayer()
            used.frame = .init(x: 20, y: 0, width: 200, height: 10)
            used.strokeColor = Session.archive.available ? NSColor.controlAccentColor.cgColor : NSColor.systemPink.cgColor
            used.fillColor = .clear
            used.lineWidth = Metrics.capacity.height
            used.lineCap = .round
            used.path = {
                $0.move(to: .init(x: 0, y: 5))
                $0.addLine(to: .init(x: CGFloat(min(Session.archive.count(.archive), Session.archive.capacity)) / .init(Session.archive.capacity) * 200, y: 5))
                return $0
            } (CGMutablePath())
            bar.layer!.addSublayer(used)
            
            [bar, count].forEach {
                addSubview($0)
                $0.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
            
            bar.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -2).isActive = true
            bar.widthAnchor.constraint(equalToConstant: 240).isActive = true
            bar.heightAnchor.constraint(equalToConstant: 10).isActive = true
            
            count.rightAnchor.constraint(equalTo: bar.leftAnchor).isActive = true
        }
    }
}
