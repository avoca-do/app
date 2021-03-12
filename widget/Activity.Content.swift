import SwiftUI
import WidgetKit

extension Activity {
    struct Content: View {
        let entry: Entry
        private let width = CGFloat(30)
        @State private var percent = NumberFormatter()
        @Environment(\.widgetFamily) private var family: WidgetFamily
        
        var body: some View {
            if entry == .empty {
                Text("Edit widget to continue")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                
            }
        }
    }
}
