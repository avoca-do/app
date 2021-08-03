import AppKit
import Combine

extension Content {
    final class Empty: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let image = Image()
            image.contentTintColor = .secondaryLabelColor
            addSubview(image)
            
            let text = Text()
            text.font = .preferredFont(forTextStyle: .title3, options: [:])
            text.textColor = .tertiaryLabelColor
            text.alignment = .center
            addSubview(text)
            
            let button = Option(title: "Start")
            addSubview(button)
            
            cloud
                .archive
                .map {
                    $0.count
                }
                .removeDuplicates()
                .sink {
                    text.stringValue = $0 == 0 ? "Welcome to Avocado\nstart your first project now" : "Choose a project to start"
                    image.image = .init(named: $0 == 0 ? "welcome" : "choose")
                    button.isHidden = $0 != 0
                }
                .store(in: &subs)
            
            image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            image.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 20).isActive = true
            
            text.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            button.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 20).isActive = true
        }
    }
}
