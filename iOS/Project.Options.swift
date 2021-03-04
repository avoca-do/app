import SwiftUI

extension Project {
    struct Options: View {
        @Binding var session: Session
        @State private var add = false
        @State private var progress = false
        @State private var settings = false
        @State private var columns = false
        
        var body: some View {
            ZStack {
                Color(.secondarySystemBackground)
                    .edgesIgnoringSafeArea(.all)
                HStack {
                    Button {
                        progress = true
                    } label: {
                        Image(systemName: "barometer")
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 64, height: 64)
                    .contentShape(Rectangle())
                    .sheet(isPresented: $progress) {
                        Progress(session: $session, progress: session.archive.progress(session.path))
                    }
                    
                    Button {
                        settings = true
                    } label: {
                        Image(systemName: "slider.vertical.3")
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 64, height: 64)
                    .contentShape(Rectangle())
                    .sheet(isPresented: $settings) {
                        Edit(session: $session, path: session.path.board)
                    }
                    
                    Button {
                        columns = true
                    } label: {
                        Image(systemName: "line.horizontal.3.decrease")
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 64, height: 64)
                    .contentShape(Rectangle())
                    .sheet(isPresented: $columns) {
                        Columns(session: $session)
                    }
                    
                    Button {
                        add = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.secondary)
                    }
                    .frame(width: 64, height: 64)
                    .contentShape(Rectangle())
                    .sheet(isPresented: $add) {
                        Editor(session: $session, write: .new(session.path.board))
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
