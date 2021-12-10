import AppKit
import Combine

extension Window.Content {
    final class Start: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            
            let text = Text(vibrancy: false)
            text.font = .preferredFont(forTextStyle: .title3)
            text.textColor = .tertiaryLabelColor
            text.alignment = .center
            addSubview(text)
            
            let button = Option(title: "Start")
            button
                .click
                .sink {
                    session.newProject()
                }
                .store(in: &subs)
            addSubview(button)
            
            cloud
                .archive
                .map {
                    $0.count
                }
                .removeDuplicates()
                .sink {
                    text.stringValue = $0 == 0
                    ? "Welcome to Avocado\nstart your first project"
                    : "Create or choose a project"
                    button.isHidden = $0 != 0
                }
                .store(in: &subs)
            
            text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            
            button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            button.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 20).isActive = true
        }
        
        override var allowsVibrancy: Bool {
            true
        }
    }
}
