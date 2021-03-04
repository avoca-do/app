import SwiftUI

extension Project {
    struct Options: View {
        @Binding var session: Session
        @State private var add = false
        
        var body: some View {
            ZStack {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea(.all)
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "barometer")
                    }
                    .frame(width: 64, height: 64)
                    .contentShape(Rectangle())
                    Button {
                        
                    } label: {
                        Image(systemName: "slider.vertical.3")
                    }
                    .frame(width: 64, height: 64)
                    .contentShape(Rectangle())
                    Button {
                        
                    } label: {
                        Image(systemName: "line.horizontal.3.decrease")
                    }
                    .frame(width: 64, height: 64)
                    .contentShape(Rectangle())
                    Button {
                        add = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .frame(width: 64, height: 64)
                    .contentShape(Rectangle())
                    .sheet(isPresented: $add) {
                        Editor(session: $session, write: .new(session.path.board))
                            .padding(.vertical)
                    }
                }
                .foregroundColor(.secondary)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
