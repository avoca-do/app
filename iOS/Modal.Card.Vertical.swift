import SwiftUI

extension Modal.Card {
    struct Vertical: View {
        @Binding var session: Session
        
        var body: some View {
            Menu {
                if session.path._card < session.archive.count(session.path.column) - 2 {
                    Button {
                        move(session.archive.count(session.path.column) - 1)
                    } label: {
                        Text("Last")
                        Image(systemName: "arrow.down.to.line")
                    }
                }
                
                if session.path._card < session.archive.count(session.path.column) - 1 {
                    Button {
                        move(session.path._card + 1)
                    } label: {
                        Text("Down")
                        Image(systemName: "arrow.down")
                    }
                }
                
                if session.path._card > 0 {
                    Button {
                        move(session.path._card - 1)
                    } label: {
                        Text("Up")
                        Image(systemName: "arrow.up")
                    }
                }
                
                if session.path._card > 1 {
                    Button {
                        move(0)
                    } label: {
                        Text("First")
                        Image(systemName: "arrow.up.to.line")
                    }
                }
                
                Text("Position ") +
                Text(NSNumber(value: session.path._card + 1), formatter: session.decimal) +
                Text(" / ") +
                Text(NSNumber(value: session.archive.count(session.path.column)), formatter: session.decimal)
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .foregroundColor(.black)
                    .font(.title3)
                    .contentShape(Rectangle())
                    .frame(width: 60)
                    .frame(maxHeight: .greatestFiniteMagnitude)
            }
        }
        
        private func move(_ position: Int) {
            withAnimation(.spring(blendDuration: 0.35)) {
                session.archive.move(session.path, vertical: position)
                session.path = .card(session.path.column, position)
            }
        }
    }
}
