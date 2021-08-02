import Foundation

extension NSAttributedString {
    class func make(_ strings: [NSAttributedString]) -> NSAttributedString {
        let mutable = NSMutableAttributedString()
        strings.forEach(mutable.append)
        return mutable
    }
}
