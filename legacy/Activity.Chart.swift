import AppKit

extension Activity {
    final class Chart: CALayer {
        required init?(coder: NSCoder) { nil }
        override init(layer: Any) {
            super.init(layer: layer)
        }
        
        init(values: [[Double]], hidden: Set<Int>, frame: CGRect) {
            super.init()
            self.frame = frame
            
            let pattern = CAShapeLayer()
            pattern.strokeColor = NSColor.labelColor.withAlphaComponent(App.dark ? 0.3 : 0.2).cgColor
            pattern.fillColor = .clear
            pattern.lineWidth = 1
            pattern.lineCap = .round
            pattern.lineDashPattern = [1, 4]
            pattern.path = { path in
                path.move(to: .zero)
                (1 ..< Metrics.chart.horizontal).map { bounds.maxX / .init(Metrics.chart.horizontal) * .init($0) }.forEach {
                    path.move(to: .init(x: $0, y: 0))
                    path.addLine(to: .init(x: $0, y: bounds.maxY))
                }
                (1 ..< Metrics.chart.vertical).map { bounds.maxY / .init(Metrics.chart.vertical) * .init($0) }.forEach {
                    path.move(to: .init(x: 0, y: $0))
                    path.addLine(to: .init(x: bounds.maxX, y: $0))
                }
                return path
            } (CGMutablePath())
            addSublayer(pattern)
            
            values.enumerated().forEach { values in
                guard !hidden.contains(values.0) && !values.1.isEmpty else { return }
                let shade = CAShapeLayer()
                shade.fillColor = NSColor.index(values.0).withAlphaComponent(0.3).cgColor
                shade.path = {
                    $0.move(to: .init(x: 0, y: 0))
                    $0.addLines(between: values.1.enumerated().map {
                        .init(x: Double(bounds.maxX) / .init(values.1.count - 1) * .init($0.0), y: .init(bounds.maxY) * $0.1)
                    })
                    $0.addLine(to: .init(x: bounds.maxX, y: 0))
                    $0.addLine(to: .init(x: 0, y: 0))
                    $0.closeSubpath()
                    return $0
                } (CGMutablePath())
                addSublayer(shade)
            }
            
            values.enumerated().forEach { values in
                guard !hidden.contains(values.0) && !values.1.isEmpty else { return }
                let road = CAShapeLayer()
                road.strokeColor = NSColor.index(values.0).cgColor
                road.fillColor = .clear
                road.lineWidth = 2
                road.lineCap = .round
                road.path = {
                    $0.move(to: .init(x: 0, y: 0))
                    $0.addLines(between: values.1.enumerated().map {
                        .init(x: Double(bounds.maxX) / .init(values.1.count - 1) * .init($0.0), y: .init(bounds.maxY) * $0.1)
                    })
                    return $0
                } (CGMutablePath())
                addSublayer(road)
            }
            
            values.enumerated().forEach { values in
                guard !hidden.contains(values.0) && !values.1.isEmpty else { return }
                (0 ..< values.1.count).forEach { index in
                    let dot = CAShapeLayer()
                    dot.fillColor = .black
                    dot.strokeColor = NSColor.index(values.0).cgColor
                    dot.lineWidth = 2
                    dot.lineCap = .round
                    dot.path = {
                        $0.addArc(center: .init(x: Double(bounds.maxX) / .init(values.1.count - 1) * .init(index), y: .init(bounds.maxY) * .init(values.1[index])), radius: 7, startAngle: .zero, endAngle: .pi * 2, clockwise: true)
                        return $0
                    } (CGMutablePath())
                    addSublayer(dot)
                }
            }
        }
    }
}
