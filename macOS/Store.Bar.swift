import AppKit
import Combine

extension Store {
    final class Bar: NSView {
        private var subs = Set<AnyCancellable>()
        
        required init?(coder: NSCoder) { nil }
        init() {
            super.init(frame: .zero)
            wantsLayer = true
            
            let shape = Shape()
            shape.strokeColor = NSColor.quaternaryLabelColor.cgColor
            
            let counter = Shape()
            counter.strokeColor = NSColor.secondaryLabelColor.cgColor
            
            [shape, counter]
                .forEach {
                    $0.frame = .init(x: 70, y: 0, width: 180, height: 60)
                    $0.lineWidth = 15
                    $0.lineDashPattern = [1, 3]
                    $0.path = {
                        $0.move(to: .init(x: 0, y: 26))
                        $0.addLine(to: .init(x: 180, y: 26))
                        return $0
                    } (CGMutablePath())
                    layer!.addSublayer($0)
                }

            let projects = Text(vibrancy: true)
            addSubview(projects)
            
            let capacity = Text(vibrancy: true)
            addSubview(capacity)
            
            projects.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            projects.rightAnchor.constraint(equalTo: capacity.leftAnchor, constant: -10).isActive = true

            capacity.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            capacity.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            
            cloud
                .archive
                .map {
                    $0.count
                }
                .removeDuplicates()
                .sink { count in
                    projects.attributedStringValue = .make {
                        $0.append(.make(NumberFormatter
                                            .decimal
                                            .string(from: .init(value: count)) ?? "",
                                        font: .monoDigit(style: .title2, weight: .regular),
                                        alignment: .right))
                        $0.linebreak()
                        $0.append(.make("Projects", font: .preferredFont(forTextStyle: .footnote),
                                        color: .secondaryLabelColor,
                                        alignment: .right))
                    }
                }
                .store(in: &subs)
            
            cloud
                .archive
                .map {
                    $0.capacity
                }
                .removeDuplicates()
                .sink { total in
                    capacity.attributedStringValue = .make {
                        $0.append(.make(NumberFormatter
                                            .decimal
                                            .string(from: .init(value: total)) ?? "",
                                        font: .monoDigit(style: .title2, weight: .regular),
                                        alignment: .right))
                        $0.linebreak()
                        $0.append(.make("Capacity", font: .preferredFont(forTextStyle: .footnote),
                                        color: .secondaryLabelColor,
                                        alignment: .right))
                    }
                }
                .store(in: &subs)
            
            cloud
                .archive
                .map {
                    .init($0.count) / .init($0.capacity)
                }
                .removeDuplicates()
                .sink {
                    counter.strokeEnd = $0
                }
                .store(in: &subs)
        }
    }
}
