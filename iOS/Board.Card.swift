import SwiftUI

extension Board {
    struct Card: View {
        @Binding var session: Session
        let board: Int
        let column: Int
        let card: Int
        @State private var selected = false
        
        var body: some View {
            if session[board][column].count > card {
                Button {
                    selected = true
                    session.card.send(.init(column: column, index: card))
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(Color.accentColor.opacity(selected ? 0.5 : 0))
                        HStack(spacing: 0) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.accentColor.opacity(0.8))
                                .frame(minHeight: 6)
                                .frame(width: Frame.indicator.hidden + Frame.indicator.visible)
                            Text(verbatim: session[board][column, card])
//                                .font(.footnote)
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                            Spacer()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical)
                    }
                }
                .onReceive(session.card) {
                    guard $0 == nil else { return }
                    selected = false
                }
            }
        }
    }
}
