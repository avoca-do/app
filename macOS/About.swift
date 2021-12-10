import AppKit

final class About: NSWindow {
    init() {
        super.init(contentRect: .init(x: 0, y: 0, width: 320, height: 360),
                   styleMask: [.closable, .titled, .fullSizeContentView], backing: .buffered, defer: true)
        toolbar = .init()
        isReleasedWhenClosed = false
        titlebarAppearsTransparent = true
        
        let content = NSVisualEffectView()
        content.state = .active
        content.material = .hudWindow
        contentView = content
        center()
        setFrameAutosaveName("About")
        
        let vibrant = Vibrant(layer: false)
        content.addSubview(vibrant)
        
        let image = Image(named: "about")
        image.contentTintColor = .secondaryLabelColor
        image.imageScaling = .scaleNone
        vibrant.addSubview(image)
        
        let name = Text(vibrancy: true)
        name.stringValue = "Avocado"
        name.font = .preferredFont(forTextStyle: .largeTitle)
        name.textColor = .labelColor
        vibrant.addSubview(name)
        
        let version = Text(vibrancy: true)
        version.stringValue = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
        version.font = .font(style: .title2, weight: .light)
        version.textColor = .secondaryLabelColor
        vibrant.addSubview(version)
        
        vibrant.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        vibrant.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        vibrant.leftAnchor.constraint(equalTo: content.leftAnchor).isActive = true
        vibrant.rightAnchor.constraint(equalTo: content.rightAnchor).isActive = true
        
        image.topAnchor.constraint(equalTo: content.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        image.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 40).isActive = true
        name.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        version.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
        version.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
    }
}
