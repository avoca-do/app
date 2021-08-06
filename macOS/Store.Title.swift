import AppKit
import Combine

extension Store {
    final class Title: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
        }
    }
}
