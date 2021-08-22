import SwiftUI

extension Sidebar {
    struct Item: View {
        @Binding var session: Session
        let index: Int
        
        var body: some View {
            Button {
                session.board = session.board == index ? nil : index
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.secondarySystemBackground))
                    HStack {
                        ZStack {
                            Circle()
                                .stroke(Color.primary, lineWidth: 1)
                                .frame(width: 28, height: 28)
                            Meter(percent: session.archive[index].progress.percentage)
                                .fill(Color.accentColor)
                                .frame(width: 28, height: 28)
                        }
                        VStack(alignment: .leading) {
                            Text(verbatim: session.archive[index].name)
                                .foregroundColor(.primary)
                                .font(.footnote)
                            Text(verbatim: RelativeDateTimeFormatter().string(from: session.archive[index].date))
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
