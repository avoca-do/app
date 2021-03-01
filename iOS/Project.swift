import SwiftUI

struct Project: View {
    @Binding var session: Session
    @State private var tab = 0
    
    var body: some View {
        Title(session: $session)
        ZStack {
            HStack {
                if tab > 0 {
                    RoundedRectangle(cornerRadius: Metrics.corners)
                        .fill(Color(.secondarySystemBackground))
                        .frame(width: Metrics.paging.width)
                        .offset(x: -Metrics.paging.offset)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 3)) {
                                tab -= 1
                            }
                        }
                }
                Spacer()
                if tab < session.archive.count(session.path) - 1 {
                    RoundedRectangle(cornerRadius: Metrics.corners)
                        .fill(Color(.secondarySystemBackground))
                        .frame(width: Metrics.paging.width)
                        .offset(x: Metrics.paging.offset)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 3)) {
                                tab += 1
                            }
                        }
                }
            }
            if tab == 0 {
                Column(session: $session, path: .column(session.path, tab))
                    .padding(.trailing, tab < session.archive.count(session.path) - 1 ? Metrics.paging.padding : 0)
                    .padding(.leading, tab > 0 ? Metrics.paging.padding : 0)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else if tab == 1 {
                Column(session: $session, path: .column(session.path, tab))
                    .padding(.trailing, tab < session.archive.count(session.path) - 1 ? Metrics.paging.padding : 0)
                    .padding(.leading, tab > 0 ? Metrics.paging.padding : 0)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
        }
//        .offset(x: Metrics.paging.offset)
        HStack {
            ForEach(0 ..< session.archive.count(session.path), id: \.self) {
                Circle()
                    .fill($0 == tab ? Color.primary : .secondary)
                    .frame(width: 6, height: 6)
            }
        }
        Options(session: $session)
    }
}
