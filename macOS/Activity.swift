import AppKit
import Combine
import Kanban

final class Activity: NSView {
    private weak var chart: Chart?
    private weak var since: Text!
    private weak var half: Text!
    private weak var base: NSView!
    private var hide = Set<Int>()
    private var subs = Set<AnyCancellable>()
    
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
        
        let since = Text()
        since.font = .preferredFont(forTextStyle: .callout)
        since.textColor = .secondaryLabelColor
        scroll.add(since)
        self.since = since
        
        let half = Text()
        half.font = .preferredFont(forTextStyle: .callout)
        half.textColor = .secondaryLabelColor
        scroll.add(half)
        self.half = half
        
        let now = Text()
        now.stringValue = NSLocalizedString("Now", comment: "")
        now.font = .preferredFont(forTextStyle: .callout)
        now.textColor = .secondaryLabelColor
        scroll.add(now)
        
        var top = base.bottomAnchor
        (0 ..< Session.archive.count(.archive)).forEach { index in
            let item = Item(index: index)
            item.click.sink { [weak self] in
                guard let self = self else { return }
                if self.hide.contains(index) {
                    self.hide.remove(index)
                    item.on()
                } else {
                    self.hide.insert(index)
                    item.off()
                }
                self.refresh()
            }.store(in: &subs)
            scroll.add(item)
            
            item.topAnchor.constraint(equalTo: top, constant: top == base.bottomAnchor ? 70 : 0).isActive = true
            item.widthAnchor.constraint(equalToConstant: 350).isActive = true
            item.leftAnchor.constraint(equalTo: base.leftAnchor).isActive = true
            top = item.bottomAnchor
        }
        
        if top != scroll.top {
            scroll.bottom.constraint(greaterThanOrEqualTo: top, constant: 50).isActive = true
        } else {
            scroll.bottom.constraint(greaterThanOrEqualTo: since.bottomAnchor, constant: 20).isActive = true
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

        since.topAnchor.constraint(equalTo: base.bottomAnchor).isActive = true
        since.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 10).isActive = true
        
        half.topAnchor.constraint(equalTo: since.topAnchor).isActive = true
        half.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
        
        now.topAnchor.constraint(equalTo: since.topAnchor).isActive = true
        now.rightAnchor.constraint(equalTo: base.rightAnchor, constant: -10).isActive = true
        
        Session.period.sink { [weak self] _ in
            self?.refresh()
        }.store(in: &subs)
    }
    
    private func refresh() {
        self.chart?.removeFromSuperlayer()
        let chart = Chart(
            values: Session.archive[activity: Session.period.value],
            hidden: hide,
            frame: .init(origin: .init(x: Metrics.chart.padding, y: Metrics.chart.padding), size: Metrics.chart.size))
        self.chart = chart
        base.layer!.addSublayer(chart)
        
        let start = Session.period.value.date
        let now = Date()
        let middle = Date(timeIntervalSince1970: start.timeIntervalSince1970 + ((now.timeIntervalSince1970 - start.timeIntervalSince1970) / 2))
        since.stringValue = RelativeDateTimeFormatter().localizedString(for: start, relativeTo: now)
        half.stringValue = RelativeDateTimeFormatter().localizedString(for: middle, relativeTo: now)
    }
}
