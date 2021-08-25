import AppKit
import Combine

final class Empty: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(board: Int) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let text = Text(vibrancy: false)
        text.font = .preferredFont(forTextStyle: .title3)
        text.textColor = .tertiaryLabelColor
        text.alignment = .center
        text.stringValue = cloud.archive.value[board].count == 0 ? "No columns in this project" : "No cards in this project"
        addSubview(text)
        
        let button = Option(title: "Add")
        button
            .click
            .sink {
                session.newCard()
            }
            .store(in: &subs)
        addSubview(button)
        
        text.bottomAnchor.constraint(equalTo: centerYAnchor).isActive = true
        text.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 20).isActive = true
        
        cloud
            .archive
            .debounce(for: .seconds(2), scheduler: DispatchQueue.main)
            .map {
                $0[board].total
            }
            .filter {
                $0 != 0
            }
            .map { _ in
                
            }
            .sink {
                session.state.send(.view(board))
            }
            .store(in: &subs)
    }
    
    override var allowsVibrancy: Bool {
        true
    }
}
