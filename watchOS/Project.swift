import SwiftUI
import Kanban

struct Project: View {
    let archive: Archive
    let board: Int
    
    var body: some View {
        List {
            Section {
                NavigationLink(destination: Activity(archive: archive, board: board)) {
                    Text("Activity")
                }
                NavigationLink(destination: Progress(archive: archive, board: board, progress: archive[board].progress)) {
                    Text("Progress")
                }
            }
            .foregroundColor(.accentColor)
            
            Section(header: Text("Columns")) {
                ForEach(0 ..< archive[board].count, id: \.self) { index in
                    NavigationLink(destination: Column(archive: archive, board: board, column: index)) {
                        Text(verbatim: archive[board][index].name)
                            .bold()
                    }
                }
            }
        }
        .font(.footnote)
        .navigationTitle(archive[board].name)
    }
}
