import AppKit
import Combine

final class Activity: NSView {
    private weak var chart: Chart?
    private weak var base: NSView!
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let scroll = Scroll()
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        scroll.verticalScroller!.controlSize = .mini
        addSubview(scroll)
        
        let base = NSView()
        base.translatesAutoresizingMaskIntoConstraints = false
        base.wantsLayer = true
        scroll.add(base)
        self.base = base
        
        var top = base.bottomAnchor
        (0 ..< Session.archive.count(.archive)).forEach {
            let item = Item(index: $0)
            scroll.add(item)
            
            item.topAnchor.constraint(equalTo: top, constant: top == base.bottomAnchor ? 50 : 0).isActive = true
            item.widthAnchor.constraint(equalToConstant: 350).isActive = true
            item.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 20).isActive = true
            top = item.bottomAnchor
        }
        
        if top != scroll.top {
            scroll.bottom.constraint(greaterThanOrEqualTo: top, constant: 50).isActive = true
        }

        scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        scroll.right.constraint(equalTo: scroll.rightAnchor).isActive = true
        scroll.bottom.constraint(greaterThanOrEqualTo: scroll.bottomAnchor).isActive = true
        
        base.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        base.centerXAnchor.constraint(equalTo: scroll.centerX).isActive = true
        base.widthAnchor.constraint(equalToConstant: Metrics.chart.size.width + (Metrics.chart.padding * 2)).isActive = true
        base.heightAnchor.constraint(equalToConstant: Metrics.chart.size.height + (Metrics.chart.padding * 2)).isActive = true

        refresh()
    }
    
    private func refresh() {
        self.chart?.removeFromSuperlayer()
        let chart = Chart(values: Session.archive[activity: .month], frame: .init(origin: .init(x: Metrics.chart.padding, y: Metrics.chart.padding), size: Metrics.chart.size))
        self.chart = chart
        base.layer!.addSublayer(chart)
    }
}
