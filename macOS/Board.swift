import AppKit
import Combine

final class Board: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(id: Int) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let separator = Separator(mode: .horizontal)
        separator.isHidden = true
        addSubview(separator)
        
        let project = Project(board: id)
        addSubview(project)
        
        separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 1).isActive = true
        separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -1).isActive = true
        
        project.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        project.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        project.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        project.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        NotificationCenter
            .default
            .publisher(for: NSView.boundsDidChangeNotification)
            .compactMap {
                $0.object as? NSClipView
            }
            .filter {
                $0 == project.contentView
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
