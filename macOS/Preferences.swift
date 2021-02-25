import AppKit
import Combine
import Kanban

final class Preferences: NSWindow {
    private var subs = Set<AnyCancellable>()
    
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 360, height: 220),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
        toolbar = .init()
        title = NSLocalizedString("Preferences", comment: "")
        titlebarAppearsTransparent = true
        collectionBehavior = .fullScreenNone
        isReleasedWhenClosed = false
        center()
        
        let title = Text()
        title.stringValue = NSLocalizedString("Features", comment: "")
        title.textColor = .secondaryLabelColor
        title.font = .preferredFont(forTextStyle: .callout)
        
        let spell = Toggle(title: NSLocalizedString("Spell checking", comment: ""))
        spell.value.value = Defaults.spell
        spell.value.dropFirst().sink {
            Defaults.spell = $0
        }.store(in: &subs)
        
        let correction = Toggle(title: NSLocalizedString("Auto correction", comment: ""))
        correction.value.value = Defaults.correction
        correction.value.dropFirst().sink {
            Defaults.correction = $0
        }.store(in: &subs)
        
        [title, spell, correction].forEach {
            contentView!.addSubview($0)
            
            $0.leftAnchor.constraint(equalTo: contentView!.leftAnchor, constant: 40).isActive = true
            $0.rightAnchor.constraint(equalTo: contentView!.rightAnchor, constant: -40).isActive = true
        }
        
        title.topAnchor.constraint(equalTo: contentView!.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        spell.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        correction.topAnchor.constraint(equalTo: spell.bottomAnchor, constant: 5).isActive = true
    }
}
