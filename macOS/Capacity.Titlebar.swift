import AppKit
import Kanban

extension Capacity {
    final class Titlebar: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            let view = NSView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.wantsLayer = true
            addSubview(view)
            
            let total = CAShapeLayer()
            total.frame = .init(x: 20, y: 0, width: 200, height: 10)
            total.strokeColor = .init(gray: 0, alpha: 0.3)
            total.fillColor = .clear
            total.lineWidth = 8
            total.lineCap = .round
            total.path = {
                $0.move(to: .init(x: 0, y: 5))
                $0.addLine(to: .init(x: 200, y: 5))
                return $0
            } (CGMutablePath())
            view.layer!.addSublayer(total)
            
            let used = CAShapeLayer()
            used.frame = .init(x: 20, y: 0, width: 200, height: 10)
            used.strokeColor = Session.archive.available ? NSColor.controlAccentColor.cgColor : NSColor.systemPink.cgColor
            used.fillColor = .clear
            used.lineWidth = 6
            used.lineCap = .round
            used.path = {
                $0.move(to: .init(x: 0, y: 5))
                $0.addLine(to: .init(x: CGFloat(min(Session.archive.count(.archive), Defaults.capacity)) / .init(Defaults.capacity) * 200, y: 5))
                return $0
            } (CGMutablePath())
            view.layer!.addSublayer(used)
            
            view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -2).isActive = true
            view.widthAnchor.constraint(equalToConstant: 240).isActive = true
            view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        }
    }
}
