import SwiftUI

extension Store {
    struct Item: View {
        let purchase: Purchases.Item
        let price: String
        let action: () -> Void
        
        var body: some View {
            VStack {
                Image(purchase.image)
                    .padding(.top)
                    .padding(.bottom)
                    .foregroundColor(.primary)
                Text(verbatim: purchase.title)
                    .foregroundColor(.primary)
                    .font(.largeTitle)
                Text(verbatim: purchase.subtitle)
                    .foregroundColor(.secondary)
                    .font(.callout)
                Text(verbatim: price)
                    .foregroundColor(.primary)
                    .padding(.top, 40)
                Button(action: action) {
                    ZStack {
                        Capsule()
                            .fill(Color.accentColor)
                        Text("PURCHASE")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 35)
                    }
                    .fixedSize()
                    .contentShape(Rectangle())
                }
                .padding(.bottom)
                Text(verbatim: purchase.info)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
                    .frame(height: 20)
            }
            .padding()
            .frame(maxWidth: .greatestFiniteMagnitude)
        }
    }
}
