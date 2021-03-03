import SwiftUI
import Kanban

//extension Board.Column {
//    struct Folded: View {
//        @Binding var session: Session
//        @Binding var fold: Set<Int>
//        let path: Kanban.Path
//        
//        var body: some View {
//            HStack {
//                Text(verbatim: session.archive[title: path])
//                    .lineLimit(1)
//                    .font(Font.body.bold())
//                Text(NSNumber(value: session.archive.count(path)), formatter: session.decimal)
//                    .font(.footnote)
//                    .foregroundColor(.secondary)
//                Spacer()
//                Image(systemName: "plus")
//                    .font(.footnote)
//            }
//            .padding()
//            .padding(.vertical, 3)
//            .padding(.leading, fold.count == session.archive.count(path.board) ? 0 : Metrics.bar.width + Metrics.indicator.visible)
//            .contentShape(Rectangle())
//            .onTapGesture {
//                fold.remove(path._column)
//            }
//        }
//    }
//}
