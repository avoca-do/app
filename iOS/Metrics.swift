import CoreGraphics

extension Metrics {
    struct sidebar {
        static let width = CGFloat(60)
    }
    
    struct paging {
        static let width = CGFloat(0.7)
        static let padding = CGFloat(4)
        static let space = CGFloat(20)
    }
    
    struct modal {
        static let height = CGFloat(600)
        static let offset = CGFloat(300)
        static let min = CGFloat(-300)
        static let max = CGFloat(120)
    }
    
    struct options {
        static let height = CGFloat(50)
    }
}
