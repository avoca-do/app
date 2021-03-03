import SwiftUI

extension Capacity {
    struct Item: View {
        let purchase: Purchases.Item
        let price: String
        let action: () -> Void
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(.secondarySystemBackground))
                VStack {
                    Image(purchase.image)
                        .padding(.top, 30)
                        .padding(.bottom)
                    Text(verbatim: purchase.subtitle)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.secondary)
                        .padding()
                    Text(verbatim: purchase.title)
                        .font(Font.largeTitle.bold())
                        .padding(.top)
                    Text(verbatim: price)
                        .bold()
                    Button(action: action) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue)
                            Text("Purchase")
                                .font(.callout)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                        }
                        .frame(width: 160)
                        .padding(.bottom)
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
