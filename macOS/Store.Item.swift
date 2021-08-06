import AppKit
import StoreKit
import Combine

extension Store {
    final class Item: NSVisualEffectView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init(product: SKProduct, price: String) {
            super.init(frame: .zero)
            state = .active
            
            let item = Purchases.Item(rawValue: product.productIdentifier)!

            let image = Image(named: item.image)
            image.contentTintColor = .secondaryLabelColor
            addSubview(image)
            
            let name = Text()
            name.font = .preferredFont(forTextStyle: .largeTitle)
            name.stringValue = item.title
            name.textColor = .labelColor
            addSubview(name)
            
            let subtitle = Text()
            subtitle.font = .preferredFont(forTextStyle: .title3)
            subtitle.stringValue = item.subtitle
            subtitle.textColor = .secondaryLabelColor
            subtitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(subtitle)
            
            let value = Text()
            value.stringValue = price
            value.font = .preferredFont(forTextStyle: .title3)
            value.textColor = .labelColor
            addSubview(value)
            
            let purchase = Purchase()
            purchase
                .click
                .sink {
                    purchases.purchase(product)
                }
                .store(in: &subs)
            addSubview(purchase)
            
            image.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
            name.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            subtitle.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
            subtitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            subtitle.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 30).isActive = true
            subtitle.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -30).isActive = true
            
            value.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 55).isActive = true
            value.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            purchase.topAnchor.constraint(equalTo: value.bottomAnchor, constant: 10).isActive = true
            purchase.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
    }
}
