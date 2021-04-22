import SwiftUI

extension Activity.Content {
    struct Chart: View {
        let values: [Double]
        
        var body: some View {
            ZStack {
                Pattern()
                    .stroke(Color.primary.opacity(0.1), style: .init(lineWidth: 1, lineCap: .round, dash: [1, 4]))
                Shade(values: values)
                    .fill(Color("avocado").opacity(0.4))
                Road(values: values)
                    .stroke(Color("avocado"), style: .init(lineWidth: 3, lineCap: .round))
                ForEach(0 ..< values.count, id: \.self) {
                    Dot(y: values[$0], index: $0, count: values.count)
                        .fill(Color(.systemBackground))
                    Dot(y: values[$0], index: $0, count: values.count)
                        .stroke(Color("avocado"), style: .init(lineWidth: 3, lineCap: .round))
                }
            }
        }
    }
}

private struct Pattern: Shape {
    func path(in rect: CGRect) -> Path {
        .init { path in
            path.move(to: .zero)
            (1 ..< Metrics.chart.horizontal).map { rect.maxX / .init(Metrics.chart.horizontal) * .init($0) }.forEach {
                path.move(to: .init(x: $0, y: 0))
                path.addLine(to: .init(x: $0, y: rect.maxY))
            }
            (1 ..< Metrics.chart.vertical).map { rect.maxY / .init(Metrics.chart.vertical) * .init($0) }.forEach {
                path.move(to: .init(x: 0, y: $0))
                path.addLine(to: .init(x: rect.maxX, y: $0))
            }
        }
    }
}

private struct Shade: Shape {
    let values: [Double]
    
    func path(in rect: CGRect) -> Path {
        .init {
            if !values.isEmpty {
                $0.move(to: .init(x: 0, y: rect.maxY))
                $0.addLines(values.enumerated().map {
                    .init(x: Double(rect.maxX) / .init(values.count - 1) * .init($0.0), y: .init(rect.maxY) - (.init(rect.maxY) * $0.1))
                })
                $0.addLine(to: .init(x: rect.maxX, y: rect.maxY))
                $0.addLine(to: .init(x: 0, y: rect.maxY))
                $0.closeSubpath()
            }
        }
    }
}

private struct Road: Shape {
    let values: [Double]

    func path(in rect: CGRect) -> Path {
        .init {
            $0.move(to: .init(x: 0, y: rect.maxY))
            if !values.isEmpty {
                $0.addLines(values.enumerated().map {
                    .init(x: Double(rect.maxX) / .init(values.count - 1) * .init($0.0), y: .init(rect.maxY) - (.init(rect.maxY) * $0.1))
                })
            } else {
                $0.addLine(to: .init(x: rect.maxX, y: rect.maxY))
            }
        }
    }
}

private struct Dot: Shape {
    let y: Double
    let index: Int
    let count: Int

    func path(in rect: CGRect) -> Path {
        .init {
            $0.addArc(center: .init(x: Double(rect.maxX) / .init(count - 1) * .init(index), y: .init(rect.maxY) - (.init(rect.maxY) * y)), radius: 7, startAngle: .zero, endAngle: .init(radians: .pi * 2), clockwise: true)
        }
    }
}
