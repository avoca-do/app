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
                    Text(verbatim: purchase.subtitle)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.secondary)
                        .padding()
                    Text(verbatim: price)
                        .bold()
                        .padding(.top, 30)
                    Button(action: action) {
                        ZStack {
                            Capsule()
                                .fill(Color.accentColor)
                            Text("Purchase")
                                .foregroundColor(.black)
                                .padding(.vertical, 8)
                        }
                        .frame(width: 160)
                        .padding(.vertical)
                    }
                    .contentShape(Rectangle())
                    .padding(.bottom)
                }
                .padding()
            }
            .padding()
        }
    }
}
