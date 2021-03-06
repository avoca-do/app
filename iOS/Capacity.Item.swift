import SwiftUI

extension Capacity {
    struct Item: View {
        let purchase: Purchases.Item
        let price: String
        let action: () -> Void
        
        var body: some View {
            Image(purchase.image)
            Text(verbatim: purchase.subtitle)
                .font(.callout)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
            Text(verbatim: purchase.title)
                .font(.largeTitle)
                .padding(.top)
            Text(verbatim: price)
                .font(.callout)
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: Metrics.corners)
                        .fill(Color.blue)
                    Text("Purchase")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                }
                .frame(maxWidth: .greatestFiniteMagnitude)
            }
            .padding(.horizontal, 20)
        }
    }
}
