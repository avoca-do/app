import AppKit

extension NSColor {
    static func index(_ index: Int) -> NSColor {
        switch index {
        case 0: return .systemBlue
        case 1: return .systemPink
        case 2: return .systemGreen
        case 3: return .systemIndigo
        case 4: return .systemOrange
        case 5: return .systemPurple
        default: return .tertiaryLabelColor
        }
    }
}
