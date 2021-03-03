import SwiftUI
import Kanban

//extension Board.Column {
//    struct Unfolded: View {
//        @Binding var session: Session
//        @Binding var fold: Set<Int>
//        let path: Kanban.Path
//        
//        var body: some View {
//            HStack(spacing: 0) {
//                Rectangle()
//                    .fill(Color.accentColor.opacity(0.01))
//                    .frame(width: Metrics.bar.width - Metrics.indicator.hidden)
//                    .allowsHitTesting(true)
//                    .onTapGesture {
//                        fold.insert(path._column)
//                    }
//                VStack(spacing: 0) {
//                    if session.archive.isEmpty(path) {
//                        HStack {
//                            Spacer()
//                                .padding(.vertical)
//                        }
//                    } else {
//                        ForEach(0 ..< session.archive.count(path), id: \.self) {
//                            Board.Card(session: $session, path: .card(path, $0))
//                            if $0 < session.archive.count(path) - 1 {
//                                Rectangle()
//                                    .fill(Color.accentColor.opacity(0.5))
//                                    .frame(height: 1)
//                                    .padding(.leading, Metrics.indicator.hidden)
//                            }
//                        }
//                    }
//                }
//            }
//            HStack {
//                VStack {
//                    Text(verbatim: session.archive[title: path])
//                        .bold()
//                        .lineLimit(1)
//                        .frame(maxWidth: Metrics.column.height - 10)
//                    Text(NSNumber(value: session.archive.count(path)), formatter: session.decimal)
//                        .lineLimit(1)
//                        .font(.footnote)
//                        .frame(maxWidth: Metrics.column.height - 10)
//                }
//                .frame(width: Metrics.column.height)
//                .contentShape(Rectangle())
//                .foregroundColor(.black)
//                .rotationEffect(.radians(.pi / -2), anchor: .leading)
//                .padding(.leading, 20)
//                .padding()
//                .offset(y: Metrics.column.height / 2)
//                Spacer()
//            }
//            .allowsHitTesting(false)
//        }
//    }
//}
