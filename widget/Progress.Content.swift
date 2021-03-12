import SwiftUI
import WidgetKit

extension Progress {
    struct Content: View {
        let entry: Entry
        @State private var percent = NumberFormatter()
        
        var body: some View {
            if entry == .empty {
                Text("No project selected.\nEdit widget for more details")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                GeometryReader { proxy in
                    
                }
                .onAppear {
                    percent.numberStyle = .percent
                }
            }
        }
    }
}
