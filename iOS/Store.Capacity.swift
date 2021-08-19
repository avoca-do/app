import SwiftUI

extension Store {
    struct Capacity: View {
        @Binding var session: Session
        
        var body: some View {
            VStack {
                ZStack {
                    Progress(value: 1)
                        .stroke(Color(.quaternaryLabel), style: .init(lineWidth: 15, dash: [1, 3]))
                    Progress(value: min(1, .init(session.archive.count) / max(.init(session.archive.capacity), 1)))
                        .stroke(Color.accentColor, style: .init(lineWidth: 15, dash: [1, 3]))
                }
                .frame(width: 180, height: 20)
                HStack(spacing: 20) {
                    Spacer()
                    Text(NSNumber(value: session.archive.count), formatter: NumberFormatter.decimal)
                        .foregroundColor(.secondary)
                        .font(.title3.monospacedDigit())
                    + Text("\nProjects")
                        .foregroundColor(.init(.tertiaryLabel))
                        .font(.caption)
                    Text(NSNumber(value: session.archive.capacity), formatter: NumberFormatter.decimal)
                        .foregroundColor(.secondary)
                        .font(.title3.monospacedDigit())
                    + Text("\nCapacity")
                        .foregroundColor(.init(.tertiaryLabel))
                        .font(.caption)
                    Spacer()
                }
                
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct Progress: Shape {
    let value: CGFloat
    
    func path(in rect: CGRect) -> Path {
        .init {
            $0.move(to: .init(x: 0, y: rect.midY))
            $0.addLine(to: .init(x: rect.maxX * value, y: rect.midY))
        }
    }
}

/*
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
 */
