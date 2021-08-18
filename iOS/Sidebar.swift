import SwiftUI

struct Sidebar: View {
    @Binding var session: Session
    @State private var detail = false
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            ScrollView {
                Spacer()
                    .frame(height: 20)
                ForEach(0 ..< session.archive.items.count, id: \.self) { index in
                    Button {
                        detail = true
                        session.section = .project(index)
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
                Spacer()
                    .frame(height: 20)
                NavigationLink(destination: link, isActive: $detail) {
                    EmptyView()
                }
            }
        }
        .navigationBarTitle("Projects", displayMode: .large)
        .onAppear {
            cloud
                .notifier
                .notify(queue: .main) {
                    if session.archive.isEmpty {
                        detail = true
                    }
                }
        }
    }
    
    @ViewBuilder private var link: some View {
        switch session.section {
        case .project:
            Project(session: $session)
        default:
            Window.Empty(session: $session)
        }
    }
}
