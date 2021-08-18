import SwiftUI

extension Sidebar {
    struct Meter: Shape {
        let percent: Double
        
        func path(in rect: CGRect) -> Path {
            .init {
                $0.move(to: .init(x: rect.midX, y: rect.midY))
                $0.addLine(to: .init(x: rect.midX, y: rect.minY + 2))
                $0.addArc(center: .init(x: rect.midX, y: rect.midY),
                          radius: (rect.width / 2) - 2,
                          startAngle: .init(degrees: -90),
                          endAngle: .init(degrees: (360 * percent) - 90),
                          clockwise: false)
                $0.addLine(to: .init(x: rect.midX, y: rect.midY))
            }
        }
    }
}
