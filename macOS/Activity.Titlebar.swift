import AppKit
import Combine
import Kanban

extension Activity {
    final class Titlebar: NSView {
        let period = PassthroughSubject<Period, Never>()
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            
            let segmented = Segmented(items: ["Day", "Week", "Month", "Year"])
            segmented.selected.value = Period.allCases.firstIndex(of: .week)!
            segmented.selected.dropFirst().sink { [weak self] in
                self?.period.send(Period.allCases[$0])
            }.store(in: &subs)
            addSubview(segmented)
            
            segmented.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            segmented.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -8).isActive = true
            segmented.widthAnchor.constraint(equalToConstant: 400).isActive = true
        }
    }
}
