import Foundation

struct Metrics {
    struct sidebar {
        static let width = CGFloat(180)
        static let padding = CGFloat(40)
    }
    
    struct board {
        static let vertical = CGFloat(16)
        static let horizontal = CGFloat(50)
        
        struct column {
            static let horizontal = CGFloat(80)
        }
        
        struct card {
            static let left = CGFloat(24)
        }
        
        struct item {
            static let padding = CGFloat(16)
            static let padding2 = padding * 2
            static let size = CGSize(width: 280, height: 3000)
        }
    }
    
    struct edit {
        static let closed = CGFloat(4)
        static let height = CGFloat(180)
        static let horizontal = CGFloat(12)
        static let vertical = CGFloat(12)
        static let right = CGFloat(60)
    }
}
