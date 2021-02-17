import AppKit

extension NSFont {
    class func light(_ adding: CGFloat = 0) -> NSFont {
        .systemFont(ofSize: systemFontSize + adding, weight: .light)
    }
    
    class func regular(_ adding: CGFloat = 0) -> NSFont {
        .systemFont(ofSize: systemFontSize + adding, weight: .regular)
    }
    
    class func medium(_ adding: CGFloat = 0) -> NSFont {
        .systemFont(ofSize: systemFontSize + adding, weight: .medium)
    }
    
    class func bold(_ adding: CGFloat = 0) -> NSFont {
        .systemFont(ofSize: systemFontSize + adding, weight: .bold)
    }
}
