import SwiftUI

extension Board {
    struct Menu: View {
        @Binding var session: Session
        @Binding var fold: Set<Int>
        let local: Namespace.ID
        @State private var settings = false
        @State private var modify = false
        @State private var add = false
        @State private var progress = false
        
        var body: some View {
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    if fold.count == session.archive.count(session.path.board) {
                        Control(image: "xmark") {
                            session.path = .archive
                        }
                        .matchedGeometryEffect(id: "close", in: local)
                    }
                    
                    Control(image: "slider.vertical.3") {
                        settings = true
                    }
                    .sheet(isPresented: $settings) {
                        Settings(session: $session)
                    }
                    
                    Control(image: "line.horizontal.3.decrease") {
                        modify = true
                    }
                    .sheet(isPresented: $modify) {
                        Modify(session: $session)
                    }
                    
                    Control(image: "plus") {
                        add = true
                    }
                    .sheet(isPresented: $add) {
                        Editor(session: $session, write: .edit(session.path.board))
                            .padding(.vertical)
                    }

                    Control(image: "barometer") {
                        progress = true
                    }
                    .sheet(isPresented: $progress) {
                        Progress(session: $session, progress: session.archive.progress(session.path))
                    }
                }
                .padding(.bottom)
                .padding(.leading, fold.count == session.archive.count(session.path.board) ? 0 : Metrics.bar.width)
            }
            .onReceive(session.purchases.open) {
                session.dismiss.send()
                session.path = .archive
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    session.purchases.open.send()
                }
            }
        }
    }
}
