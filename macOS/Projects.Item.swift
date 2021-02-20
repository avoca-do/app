import AppKit

extension Projects {
    final class Item: NSView {
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            let edit = Edit()
            let board = Board()
            
            [board, edit].forEach {
                addSubview($0)
                $0.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
                $0.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            }
            
            edit.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            edit.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            board.topAnchor.constraint(equalTo: edit.bottomAnchor).isActive = true
            board.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
}
