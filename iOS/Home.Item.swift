import SwiftUI

extension Home {
    struct Item: View {
        @Binding var session: Session
        let board: Int
        @State private var date = ""
        
        var body: some View {
            Button {
                UIApplication.shared.resign()
                session.board.send(board)
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 150)
                        .fill(Color.accentColor)
                    HStack {
                        VStack(alignment: .leading) {
                            Text(verbatim: session[board].name)
                                .font(.headline)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundColor(.black)
                            Text(verbatim: date)
                                .font(.caption2)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    .padding()
                }
                .contentShape(Rectangle())
            }
            .padding(.horizontal)
            .onAppear {
                date = RelativeDateTimeFormatter().localizedString(for: session[board].date, relativeTo: .init())
            }
        }
    }
}
