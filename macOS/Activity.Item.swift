import AppKit

extension Activity {
    final class Item: Control {
        let index: Int
        private weak var circle: NSView!
        private weak var label: Text!
        
        required init?(coder: NSCoder) { nil }
        init(index: Int) {
            self.index = index
            super.init()
            translatesAutoresizingMaskIntoConstraints = false
            
            let circle = NSView()
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.wantsLayer = true
            circle.layer!.cornerRadius = Metrics.chart.circle / 2
            addSubview(circle)
            self.circle = circle
            
            let label = Text()
            label.stringValue = Session.archive[name: .board(index)]
            label.font = .preferredFont(forTextStyle: .body)
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(label)
            self.label = label
            
            bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 12).isActive = true
            
            circle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            circle.widthAnchor.constraint(equalToConstant: Metrics.chart.circle).isActive = true
            circle.heightAnchor.constraint(equalTo: circle.widthAnchor).isActive = true
            circle.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
            
            label.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
            label.leftAnchor.constraint(equalTo: circle.rightAnchor, constant: 4).isActive = true
            label.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -12).isActive = true
            
            on()
        }
        
        func on() {
            circle.layer!.backgroundColor = NSColor.index(index).cgColor
            circle.alphaValue = 1
            label.textColor = .labelColor
        }
        
        func off() {
            circle.layer!.backgroundColor = NSColor.tertiaryLabelColor.cgColor
            circle.alphaValue = App.dark ? 0.5 : 0.2
            label.textColor = .secondaryLabelColor
        }
    }
}
