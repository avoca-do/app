import SwiftUI
import Kanban

struct Column: View {
    let archive: Archive
    let board: Int
    let column: Int
    
    var body: some View {
        List {
            ForEach(0 ..< archive[board][column].count, id: \.self) { index in
                Text(NSNumber(value: index + 1), formatter: NumberFormatter.decimal)
                    .foregroundColor(.accentColor)
                    .font(.footnote.monospacedDigit())
                + Text(verbatim: " " + archive[board][column][index].content)
                    .kerning(1)
                    .font(.footnote)
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(CarouselListStyle())
        .navigationTitle(archive[board][column].name)
    }
}
