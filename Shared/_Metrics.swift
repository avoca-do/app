import CoreGraphics

struct Metrics {
    static let corners = CGFloat(8)
    
    struct accent {
        static let low = Double(0.2)
        static let high = Double(0.5)
    }
    
    struct card {
        static let line = CGFloat(1)
        static let circle = CGFloat(6)
        static let radius = circle / 2
    }
    
    struct progress {
        static let stroke = CGFloat(30)
    }
    
    struct capacity {
        static let height = CGFloat(6)
    }
    
    struct chart {
        static let horizontal = 12
        static let vertical = 5
        static let circle = CGFloat(16)
    }
}
