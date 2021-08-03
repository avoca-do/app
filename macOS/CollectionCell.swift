import AppKit

class CollectionCell<Info>: CALayer where Info : CollectionItemInfo {
    var first = false
    var item: CollectionItem<Info>?
    
    required init?(coder: NSCoder) { nil }
    override init(layer: Any) { super.init(layer: layer) }
    required override init() {
        super.init()
    }
    
    var state = CollectionCellState.none {
        didSet {
            switch state {
            case .none:
                backgroundColor = .clear
            case .highlighted:
                backgroundColor = NSColor.labelColor.withAlphaComponent(0.03).cgColor
            case .pressed:
                backgroundColor = NSColor.quaternaryLabelColor.cgColor
            }
        }
    }
    
    final override func hitTest(_: CGPoint) -> CALayer? {
        nil
    }
    
    final override class func defaultAction(forKey: String) -> CAAction? {
        NSNull()
    }
}
