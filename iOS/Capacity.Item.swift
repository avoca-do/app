import SwiftUI

extension Capacity {
    struct Item: View {
        let purchase: Purchases.Item
        let price: String
        let action: () -> Void
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.background)
                VStack {
                    Image(purchase.image)
                    Text(verbatim: purchase.title)
                        .font(Font.largeTitle.bold())
                    Text(verbatim: price)
                        .bold()
                        .padding(.top, 40)
                    Button(action: action) {
                        ZStack {
                            Capsule()
                                .fill(Color.blue)
                            Text("Purchase")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                        }
                        .frame(width: 160)
                        .padding(.bottom)
                    }
                    .contentShape(Rectangle())
                    Text(verbatim: purchase.subtitle)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.secondary)
                        .padding()
                }
                .padding()
            }
            .padding()
        }
    }
}
