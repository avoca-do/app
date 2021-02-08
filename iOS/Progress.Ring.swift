import SwiftUI

extension Progress {
    struct Ring: Shape {
        let amount: Double
        
        func path(in rect: CGRect) -> Path {
            .init {
                let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
                let radius = (min(rect.width, rect.height) / 2) - Metrics.progress.stroke
                $0.addArc(center: center, radius: radius, startAngle: .init(degrees: -90), endAngle: .init(degrees: (360 * amount) - 90), clockwise: false)
            }
        }
    }
}
