import SwiftUI

struct Sidebar: View {
    @Binding var session: Session
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                ForEach(0 ..< session.archive.items.count, id: \.self) { index in
                    NavigationLink(destination: Project(session: $session)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.tertiarySystemBackground))
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(verbatim: session.archive.items[index].name)
                                        .foregroundColor(.primary)
                                        .font(.footnote)
                                    Text(verbatim: RelativeDateTimeFormatter().string(from: session.archive.items[index].date))
                                        .foregroundColor(.secondary)
                                        .font(.footnote)
                                }
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
        .navigationBarTitle("Projects", displayMode: .large)
    }
}
