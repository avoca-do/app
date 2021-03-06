import AppKit
import Combine
import Kanban

final class Capacity: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        let title = Text()
        title.stringValue = NSLocalizedString("You can purchase more capacity.\nYou could also delete any existing project to free up capacity.", comment: "")
        title.font = .preferredFont(forTextStyle: .body)
        title.textColor = .secondaryLabelColor
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(title)
        
        title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        title.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -30).isActive = true
        
        Session.purchases.loading.combineLatest(Session.purchases.products, Session.purchases.error).sink { [weak self] in
            guard let self = self else { return }
            self.subviews.filter { $0 != title }.forEach { $0.removeFromSuperview() }
            if let error = $0.2 {
                let text = Text()
                text.stringValue = error
                text.textColor = .secondaryLabelColor
                text.font = .preferredFont(forTextStyle: .body)
                text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                
                self.addSubview(text)
                text.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 30).isActive = true
                text.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
                text.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -30).isActive = true
            } else if $0.0 || $0.1.isEmpty {
                let text = Text()
                text.stringValue = NSLocalizedString("Loading...", comment: "")
                text.textColor = .tertiaryLabelColor
                text.font = .preferredFont(forTextStyle: .title3)
                self.addSubview(text)
                
                text.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                text.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            } else if let product = $0.1.first {
                let item = Purchases.Item(rawValue: product.0.productIdentifier)!
                let base = NSView()
                base.translatesAutoresizingMaskIntoConstraints = false
                base.wantsLayer = true
                base.layer!.backgroundColor = NSColor.labelColor.withAlphaComponent(0.05).cgColor
                base.layer!.cornerRadius = Metrics.corners
                self.addSubview(base)
                
                let image = NSImageView(image: NSImage(named: item.image)!)
                image.translatesAutoresizingMaskIntoConstraints = false
                base.addSubview(image)
                
                let name = Text()
                name.font = .preferredFont(forTextStyle: .largeTitle)
                name.stringValue = item.title
                base.addSubview(name)
                
                let subtitle = Text()
                subtitle.font = .preferredFont(forTextStyle: .callout)
                subtitle.stringValue = item.subtitle
                subtitle.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                base.addSubview(subtitle)
                
                let price = Text()
                price.stringValue = product.1
                price.font = .preferredFont(forTextStyle: .body)
                base.addSubview(price)
                
                let purchase = Control.Rectangle(title: NSLocalizedString("Purchase", comment: ""))
                purchase.layer!.backgroundColor = NSColor.systemBlue.cgColor
                purchase.text.textColor = .white
                purchase.click.sink {
                    Session.purchases.purchase(product.0)
                }.store(in: &self.subs)
                base.addSubview(purchase)
                
                base.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 20).isActive = true
                base.leftAnchor.constraint(equalTo: title.leftAnchor).isActive = true
                base.widthAnchor.constraint(equalToConstant: 460).isActive = true
                base.heightAnchor.constraint(equalToConstant: 300).isActive = true
                
                image.topAnchor.constraint(equalTo: base.topAnchor, constant: 30).isActive = true
                image.leftAnchor.constraint(equalTo: base.leftAnchor, constant: 30).isActive = true
                
                name.bottomAnchor.constraint(equalTo: price.topAnchor, constant: -5).isActive = true
                name.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
                
                subtitle.topAnchor.constraint(equalTo: image.topAnchor).isActive = true
                subtitle.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 20).isActive = true
                subtitle.rightAnchor.constraint(lessThanOrEqualTo: base.rightAnchor, constant: -30).isActive = true
                
                price.bottomAnchor.constraint(equalTo: purchase.topAnchor, constant: -10).isActive = true
                price.centerXAnchor.constraint(equalTo: purchase.centerXAnchor).isActive = true
                
                purchase.bottomAnchor.constraint(equalTo: base.bottomAnchor, constant: -30).isActive = true
                purchase.centerXAnchor.constraint(equalTo: base.centerXAnchor).isActive = true
                purchase.widthAnchor.constraint(equalToConstant: 120).isActive = true
            }
        }.store(in: &subs)
        
        Session.purchases.load()
    }
}
