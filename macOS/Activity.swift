import AppKit
import Kanban

final class Activity: NSPopover {
    private weak var chart: Chart?
    
    required init?(coder: NSCoder) { nil }
    override init() {
        super.init()
        behavior = .semitransient
        contentSize = .init(width: 420, height: 300)
        contentViewController = .init()
        contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
        
        let period = NSSegmentedControl(labels: ["Year", "Month", "Week", "Day"], trackingMode: .selectOne, target: self, action: #selector(self.period))
        period.translatesAutoresizingMaskIntoConstraints = false
        period.selectedSegment = 1
        view.addSubview(period)
        
        period.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        period.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 60).isActive = true
        period.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -60).isActive = true
        
        self.period(period)
    }
    
    @objc private func period(_ segmented: NSSegmentedControl) {
        chart?.removeFromSuperview()
        let period: Period
        switch segmented.selectedSegment {
        case 1:
            period = .month
        case 2:
            period = .week
        case 3:
            period = .day
        default:
            period = .year
        }
        let chart = Chart(frame: .init(origin: .zero, size: .init(width: contentSize.width, height: contentSize.height - 20)),
                          first: period.date,
                          values: cloud.archive.value.activity(period: period))
        view.addSubview(chart)
        self.chart = chart
    }
}
