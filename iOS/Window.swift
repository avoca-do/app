import SwiftUI

struct Window: View {
    @Binding var session: Session
    @Namespace private var namespace
    
    var body: some View {
        switch session.section {
        case .projects:
            Circle()
        }
    }
}
