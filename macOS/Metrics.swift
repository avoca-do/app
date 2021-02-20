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
}
