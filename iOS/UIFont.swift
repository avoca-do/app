import UIKit

extension UIFont {
    class func font(style: TextStyle, weight: Weight) -> UIFont {
        .systemFont(ofSize: UIFont.preferredFont(forTextStyle: style).pointSize, weight: weight)
    }
    
    class func monoDigit(style: TextStyle, weight: Weight) -> UIFont {
        .monospacedDigitSystemFont(ofSize: UIFont.preferredFont(forTextStyle: style).pointSize, weight: weight)
    }
}
