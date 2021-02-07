import CoreGraphics

struct Frame {
    struct bar {
        static let width = CGFloat(60)
    }
    
    struct column {
        static let height = CGFloat(180)
    }
    
    struct indicator {
        static let hidden = CGFloat(6)
        static let visible = CGFloat(6)
    }
    
    struct modal {
        static let height = CGFloat(540)
        static let offset = CGFloat(120)
    }
}
