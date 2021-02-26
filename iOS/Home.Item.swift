import SwiftUI
import Kanban

extension Home {
    struct Item: View {
        @Binding var session: Session
        let path: Kanban.Path
        let global: Namespace.ID
        @State private var date = ""
        
        var body: some View {
            Button {
                UIApplication.shared.resign()
                session.path = path
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accentColor)
                        .matchedGeometryEffect(id: "bar\(path._board)", in: global)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(verbatim: session.archive[name: path])
                                .font(.headline)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.black)
                            Text(verbatim: date)
                                .font(.footnote)
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    .padding()
                    .matchedGeometryEffect(id: "text\(path._board)", in: global)
                }
                .contentShape(Rectangle())
            }
            .padding(.horizontal)
            .onAppear(perform: refresh)
            .onChange(of: session.archive.count(session.path)) { _ in
                refresh()
            }
        }
        
        private func refresh() {
            date = RelativeDateTimeFormatter().string(from: session.archive.date(path), to: .init())
        }
    }
}
