import Foundation

struct Metrics {
    struct sidebar {
        static let width = CGFloat(180)
        static let padding = CGFloat(40)
    }
    
    struct board {
        struct column {
            static let vertical = CGFloat(16)
            static let horizontal = CGFloat(16)
        }
        
        struct item {
            static let size = CGSize(width: 180, height: 3000)
            static let padding = CGFloat(10)
        }
    }
    
    struct edit {
        static let closed = CGFloat(4)
        static let height = CGFloat(200)
        static let horizontal = CGFloat(12)
        static let vertical = CGFloat(12)
        static let right = CGFloat(60)
    }
}
