import AppKit
import StoreKit
import Combine

final class Store: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 480, height: 680),
                   styleMask: [.closable, .miniaturizable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        center()
        setFrameAutosaveName("Store")
        
        let bar = NSTitlebarAccessoryViewController()
        bar.view = Bar()
        bar.layoutAttribute = .top
        addTitlebarAccessoryViewController(bar)
        
        purchases
            .loading
            .removeDuplicates()
            .combineLatest(purchases
                            .products
                            .removeDuplicates {
                                $0.first?.product == $1.first?.product
                            },
                           purchases
                            .error
                            .removeDuplicates()
            )
            .sink { [weak self] (loading: Bool, purchases: [(product: SKProduct, price: String)], error: String?) in
                if let error = error {
                    self?.contentView = View.error(message: error)
                } else if loading {
                    self?.contentView = View.loading()
                } else if let item = purchases.first {
                    self?.contentView = View.item(product: item.product, price: item.price)
                }
            }
            .store(in: &subs)
        
        purchases.load()
    }
}
