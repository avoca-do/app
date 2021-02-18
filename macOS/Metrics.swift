import Foundation

struct Metrics {
    struct sidebar {
        static let width = CGFloat(180)
        static let padding = CGFloat(40)
    }
    
    struct board {
        struct card {
            static let vertical = CGFloat(10)
            static let horizontal = CGFloat(10)
        }
        
        struct column {
            static let size = CGSize(width: 200, height: 2000)
        }
    }
}
