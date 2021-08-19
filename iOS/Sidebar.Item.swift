import SwiftUI

extension Sidebar {
    struct Item: View {
        @Binding var session: Session
        @Binding var detail: Bool
        let index: Int
        
        var body: some View {
            Button {
                detail = true
                session.board = index
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.tertiarySystemBackground))
                    HStack {
                        ZStack {
                            Circle()
                                .stroke(Color(.tertiaryLabel), lineWidth: 1)
                                .frame(width: 26, height: 26)
                            Meter(percent: session.archive.items[index].progress.percentage)
                                .fill(Color.accentColor)
                                .frame(width: 28, height: 28)
                        }
                        VStack(alignment: .leading) {
                            Text(verbatim: session.archive.items[index].name)
                                .foregroundColor(.primary)
                                .font(.footnote)
                            Text(verbatim: RelativeDateTimeFormatter().string(from: session.archive.items[index].date))
                                .foregroundColor(.secondary)
                                .font(.footnote)
                        }
                        .padding(.leading, 4)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                    }
                    .padding()
                }
                .padding(.horizontal)
                .contentShape(Rectangle())
            }
        }
    }
}
