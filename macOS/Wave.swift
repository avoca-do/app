import AppKit
import Kanban

final class Wave: NSPopover {
    private weak var chart: Chart?
    private let board: Int
    
    required init?(coder: NSCoder) { nil }
    init(board: Int) {
        self.board = board
        
        super.init()
        behavior = .semitransient
        contentSize = .init(width: 680, height: 420)
        contentViewController = .init()
        contentViewController!.view = .init(frame: .init(origin: .zero, size: contentSize))
        
        let period = NSSegmentedControl(labels: ["Start", "Year", "Month", "Week", "Day"], trackingMode: .selectOne, target: self, action: #selector(self.period))
        period.translatesAutoresizingMaskIntoConstraints = false
        period.selectedSegment = 2
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
            period = .year
        case 2:
            period = .month
        case 3:
            period = .week
        case 4:
            period = .day
        default:
            period = .custom(cloud.archive.value[board].start)
        }
        let chart = Chart(frame: .init(origin: .zero, size: .init(width: contentSize.width, height: contentSize.height - 60)),
                          first: period.date,
                          values: cloud.archive.value[board].activity(period: period))
        view.addSubview(chart)
        self.chart = chart
    }
}
