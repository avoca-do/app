import AppKit
import Combine

final class Project: NSView {
    private var subs = Set<AnyCancellable>()
    
    required init?(coder: NSCoder) { nil }
    init(board: Int) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let card = CurrentValueSubject<Bool, Never>(false)
        session
            .card
            .subscribe(card)
            .store(in: &subs)
        
        cloud
            .archive
            .map {
                $0[board]
            }
            .removeDuplicates()
            .combineLatest(card
                            .removeDuplicates())
            .sink { [weak self] in
                guard let self = self else { return }
                self
                    .subviews
                    .forEach {
                        $0.removeFromSuperview()
                    }
                
                let view: NSView = $0.1 ? Card(board: board) : Board(board: board)
                self.addSubview(view)
                
                view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            }
            .store(in: &subs)
    }
}
