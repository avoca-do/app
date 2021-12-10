import AppKit
import Combine

final class Sidebar: NSView {
    static let width = CGFloat(260)
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let separatorVertical = Separator(mode: .vertical)
        addSubview(separatorVertical)
        
        let separator = Separator(mode: .horizontal)
        separator.isHidden = true
        addSubview(separator)
        
        let list = List()
        addSubview(list)
        
        widthAnchor.constraint(equalToConstant: Self.width).isActive = true
        
        separatorVertical.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        separatorVertical.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorVertical.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        separator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: separatorVertical.leftAnchor).isActive = true
        
        list.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        list.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        list.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        list.rightAnchor.constraint(equalTo: separatorVertical.leftAnchor).isActive = true
        
        NotificationCenter
            .default
            .publisher(for: NSView.boundsDidChangeNotification)
            .compactMap {
                $0.object as? NSClipView
            }
            .filter {
                $0 == list.contentView
            }
            .map {
                $0.bounds.minY < 25
            }
            .removeDuplicates()
            .sink {
                separator.isHidden = $0
            }
            .store(in: &subs)
    }
}
