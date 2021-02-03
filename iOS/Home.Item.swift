import SwiftUI

extension Home {
    struct Item: View {
        @Binding var session: Session
        let board: Int
        let global: Namespace.ID
        @State private var date = ""
        
        var body: some View {
            Button {
                UIApplication.shared.resign()
                session.board.send(board)
            } label: {
                ZStack {
                    Capsule()
                        .fill(Color.accentColor)
                        .matchedGeometryEffect(id: "bar\(board)", in: global)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(verbatim: session[board].name)
                                .font(.headline)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.black)
                            Text(verbatim: date)
                                .font(.caption2)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    .padding()
                    .matchedGeometryEffect(id: "text\(board)", in: global)
                }
                .contentShape(Rectangle())
            }
            .padding(.horizontal)
            .onAppear(perform: refresh)
            .onChange(of: session.count) { _ in
                refresh()
            }
        }
        
        private func refresh() {
            date = RelativeDateTimeFormatter().localizedString(for: session[board].date, relativeTo: .init())
        }
    }
}
