import AppKit
import StoreKit
import Combine

extension Store {
    final class View: NSVisualEffectView {
        class func item(product: SKProduct, price: String) -> Self {
            let view = Self()
            
            let vibrant = Vibrant(layer: false)
            view.addSubview(vibrant)
            
            let item = Purchases.Item(rawValue: product.productIdentifier)!

            let image = Image(named: item.image)
            image.contentTintColor = .secondaryLabelColor
            view.addSubview(image)
            
            let name = Text(vibrancy: true)
            name.font = .preferredFont(forTextStyle: .largeTitle)
            name.stringValue = item.title
            name.textColor = .labelColor
            vibrant.addSubview(name)
            
            let subtitle = Text(vibrancy: true)
            subtitle.font = .preferredFont(forTextStyle: .title3)
            subtitle.stringValue = item.subtitle
            subtitle.textColor = .secondaryLabelColor
            vibrant.addSubview(subtitle)
            
            let info = Text(vibrancy: true)
            info.font = .preferredFont(forTextStyle: .body)
            info.stringValue = item.info
            info.textColor = .tertiaryLabelColor
            info.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            vibrant.addSubview(info)
            
            let value = Text(vibrancy: true)
            value.stringValue = price
            value.font = .preferredFont(forTextStyle: .title3)
            value.textColor = .labelColor
            vibrant.addSubview(value)
            
            let purchase = Purchase()
            purchase
                .click
                .sink {
                    purchases.purchase(product)
                }
                .store(in: &view.subs)
            view.addSubview(purchase)
            
            vibrant.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            vibrant.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            vibrant.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            vibrant.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
            name.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            subtitle.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 15).isActive = true
            subtitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            info.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 10).isActive = true
            info.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            info.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 50).isActive = true
            info.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -50).isActive = true
            
            value.bottomAnchor.constraint(equalTo: purchase.topAnchor, constant: -10).isActive = true
            value.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            purchase.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
            purchase.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            return view
        }
        
        class func error(message: String) -> Self {
            let view = Self()
            
            let text = Text(vibrancy: true)
            text.stringValue = message
            text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            text.textColor = .secondaryLabelColor
            text.font = .preferredFont(forTextStyle: .title3)
            view.addSubview(text)
            
            text.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50).isActive = true
            text.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -50).isActive = true
            text.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
            return view
        }
        
        class func loading() -> Self {
            let view = Self()
            
            let icon = Image(icon: "hourglass.bottomhalf.fill")
            icon.symbolConfiguration = .init(textStyle: .largeTitle)
            icon.contentTintColor = .tertiaryLabelColor
            view.addSubview(icon)
            
            icon.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            return view
        }
        
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            state = .active
        }
    }
}
