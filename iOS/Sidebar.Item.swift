import SwiftUI

extension Sidebar {
    struct Item: View {
        @Binding var session: Session
        let index: Int
        
        var body: some View {
            Button {
                guard session.board != index else {
                    session.board = nil
                    return
                }
                session.column = 0
                session.board = index
            } label: {
                HStack {
                    ZStack {
                        Circle()
                            .stroke(Color.primary, lineWidth: 1)
                            .frame(width: 28, height: 28)
                            .padding(5)
                        Meter(percent: session.archive[index].progress.percentage)
                            .fill(Color.accentColor)
                            .frame(width: 28, height: 28)
                    }
                    .fixedSize()
                    VStack(alignment: .leading) {
                        Text(verbatim: session.archive[index].name)
                            .foregroundColor(.primary)
                            .font(.footnote)
                        Text(verbatim: RelativeDateTimeFormatter().string(from: session.archive[index].date))
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                    .padding(.trailing)
                    .padding(.vertical)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(alignment: .leading)
                    Rectangle()
                        .stroke(Color(.tertiarySystemFill), lineWidth: 1)
                        .frame(height: 1)
                }
                .padding(.horizontal)
                .contentShape(Rectangle())
            }
        }
    }
}
