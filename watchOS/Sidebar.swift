import SwiftUI
import Kanban

struct Sidebar: View {
    let archive: Archive
    
    var body: some View {
        if archive.isEmpty {
            Text("No projects started, continue on your iPhone, iPad or Mac")
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        } else {
            NavigationView {
                List {
                    ForEach(0 ..< archive.count, id: \.self) { index in
                        NavigationLink(destination: Project(archive: archive, board: index)) {
                            Group {
                                Text(verbatim: archive[index].name)
                                    .font(.footnote.bold())
                                + Text(verbatim: "\n" + RelativeDateTimeFormatter().string(from: archive[index].date))
                                    .foregroundColor(.secondary)
                                    .font(.caption2)
                            }
                            .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                        }
                    }
                }
            }
        }
    }
}
