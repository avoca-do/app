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

            let image = Image(named: item.image, vibrancy: true)
            image.contentTintColor = .secondaryLabelColor
            addSubview(image)
            
            let name = Text(vibrancy: true)
            name.font = .preferredFont(forTextStyle: .largeTitle)
            name.stringValue = item.title
            name.textColor = .labelColor
            addSubview(name)
            
            let subtitle = Text(vibrancy: true)
            subtitle.font = .preferredFont(forTextStyle: .title3)
            subtitle.stringValue = item.subtitle
            subtitle.textColor = .secondaryLabelColor
            addSubview(subtitle)
            
            let info = Text(vibrancy: true)
            info.font = .preferredFont(forTextStyle: .body)
            info.stringValue = item.info
            info.textColor = .tertiaryLabelColor
            info.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(info)
            
            let value = Text(vibrancy: true)
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
            
            subtitle.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 15).isActive = true
            subtitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            info.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 10).isActive = true
            info.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            info.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 50).isActive = true
            info.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -50).isActive = true
            
            value.bottomAnchor.constraint(equalTo: purchase.topAnchor, constant: -10).isActive = true
            value.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            purchase.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
            purchase.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
    }
}
