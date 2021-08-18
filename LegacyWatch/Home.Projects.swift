import SwiftUI

extension Home {
    struct Projects: View {
        @Binding var session: Session
        
        var body: some View {
            if session.archive.isEmpty(.archive) {
                Text("No projects")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            } else {
                ScrollView {
                    ForEach(0 ..< session.archive.count(.archive), id: \.self) { index in
                        Button {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                session.path = .board(index)
                            }
                        } label: {
                            VStack {
                                Text(verbatim: session.archive[name: .board(index)])
                                    .font(Font.footnote.bold())
                                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                                Text(verbatim: RelativeDateTimeFormatter().string(from: session.archive.date(.board(index)), to: .init()))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                            }
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                        }
                    }
                }
            }
        }
    }
}
