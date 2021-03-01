import CoreGraphics

extension Metrics {
    struct sidebar {
        static let width = CGFloat(60)
    }
    
    struct paging {
        static let width = CGFloat(120)
        static let offset = CGFloat(90)
        static let padding = width - offset
    }
    
    
    
    
    
    
    
    
    
    
    struct bar {
        static let width = CGFloat(60)
    }
    
    struct column {
        static let height = CGFloat(160)
    }
    
    struct indicator {
        static let hidden = CGFloat(6)
        static let visible = CGFloat(6)
    }
    
    struct modal {
        static let height = CGFloat(540)
        static let offset = CGFloat(120)
        static let min = CGFloat(-100)
        static let max = CGFloat(100)
    }
    
    struct progress {
        static let stroke = CGFloat(30)
    }
}
