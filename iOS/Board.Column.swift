import SwiftUI
import Kanban

extension Board {
    struct Column: View {
        @Binding var session: Session
        let column: Kanban.Board.Column
        
        var body: some View {
            if session.board != nil {
                ZStack {
                    VStack {
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
                            .padding()
                            Spacer()
                        }
                        if column != session.board!.columns.last! {
                            Rectangle()
                                .fill(Color(.secondarySystemFill))
                                .frame(height: 1)
                        }
                    }
                    .background(session.board!.columns.firstIndex(of: column)! % 2 == 0 ? .clear : Color(.tertiarySystemBackground))
                    .padding(.leading, 50)
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
}
