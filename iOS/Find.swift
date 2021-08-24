import SwiftUI
import Kanban

struct Find: View {
    @Binding var session: Session
    let id: UUID
    @State private var search = ""
    @State private var found = [Found]()
    
    var body: some View {
        ZStack {
            if found.isEmpty {
                Image("blank")
                    .padding(.top, 100)
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
            } else {
                ScrollView(showsIndicators: false) {
                    Spacer()
                        .frame(height: 20)

                    Spacer()
                        .frame(height: 20)
                }
                .animation(.spring(blendDuration: 0.2))
            }
            Bar(session: $session, search: $search)
                .frame(height: 0)
        }
        .onChange(of: search) { _ in
            
        }
    }
}
