import SwiftUI
import Kanban

struct Find: View {
    @Binding var session: Session
    @State private var search = ""
    @State private var found = [Found]()
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .edgesIgnoringSafeArea(.all)
            if found.isEmpty {
                Image(systemName: "magnifyingglass")
                    .font(.largeTitle)
                    .foregroundColor(.init(.tertiaryLabel))
            } else {
                ScrollView {
                    Spacer()
                        .frame(height: 20)
                    ForEach(0 ..< found.count, id: \.self) { index in
                        if index > 0 {
                            Rectangle()
                                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
                                .frame(height: 1)
                                .padding(.horizontal)
                        }
                        
                        Item(content: found[index].content, breadcrumbs: found[index].breadcrumbs) {
                            visible.wrappedValue.dismiss()
                            session.column = found[index].path.column
                            session.board = found[index].path.board
                        }
                    }
                    Spacer()
                        .frame(height: 20)
                }
                .animation(.spring(blendDuration: 0.2))
            }
            Bar(session: $session, search: $search)
                .frame(height: 0)
        }
        .onChange(of: search) {
            cloud
                .find(search: $0) {
                    found = $0
                }
        }
    }
}
