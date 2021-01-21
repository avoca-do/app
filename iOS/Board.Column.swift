import SwiftUI
import Kanban

extension Board {
    struct Column: View {
        let column: Kanban.Board.Column
        
        var body: some View {
            ZStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(verbatim: "Hello")
                        Text(verbatim: "World")
                        Text(verbatim: "Lorem ipsum")
                        Text(verbatim: "Lorem ipsum Lorem ipsum")
                        Text(verbatim: "Lorem ipsum")
                        Text(verbatim: "Lorem ipsum Lorem ipsum")
                        Text(verbatim: "Lorem ipsum Lorem ipsum Lorem ipsum")
                        Text(verbatim: "Lorem ipsum")
                        Text(verbatim: "Lorem ipsum Lorem ipsum")
                    }
                    .padding(.leading, 70)
                    Spacer()
                }
                HStack {
                    Text(verbatim: column.name.uppercased())
                        .rotationEffect(.radians(.pi / -2), anchor: .bottomLeading)
                        .font(.system(.body, design: .monospaced))
                        .padding(.leading, 25)
                        .padding()
                        .offset(y: .init(column.name.count) * 4)
                    Spacer()
                }
            }
        }
    }
}
