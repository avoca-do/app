import SwiftUI
import StoreKit

struct Store: View {
    @Binding var session: Session
    @State private var products = [(product: SKProduct, price: String)]()
    @State private var error: String?
    @State private var loading = true
    @State private var why = false
    @State private var alternatives = false
    
    var body: some View {
        Popup(title: "", leading: {
            ZStack {
                Radiator(value: 1)
                    .stroke(Color(.quaternaryLabel), style: .init(lineWidth: 20, dash: [1, 3]))
                Radiator(value: min(1, .init(session.archive.count) / max(.init(session.archive.capacity), 1)))
                    .stroke(Color.accentColor, style: .init(lineWidth: 20, dash: [1, 3]))
            }
            .frame(width: 260)
        }) {
            if let error = error {
                Text(verbatim: error)
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude, alignment: .topLeading)
            } else if loading {
                Image(systemName: "hourglass.bottomhalf.fill")
                    .font(.largeTitle)
                    .foregroundColor(.init(.tertiaryLabel))
                    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
            } else {
                ScrollView {
                    HStack(spacing: 30) {
                        Spacer()
                        Text(NSNumber(value: session.archive.count), formatter: NumberFormatter.decimal)
                            .foregroundColor(.primary)
                            .font(.title3.monospacedDigit())
                        + Text("\nPROJECTS")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        Text(NSNumber(value: session.archive.capacity), formatter: NumberFormatter.decimal)
                            .foregroundColor(.primary)
                            .font(.title3.monospacedDigit())
                        + Text("\nCAPACITY")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        Spacer()
                    }
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    ForEach(products, id: \.product.productIdentifier) { product in
                        Item(purchase: Purchases.Item(rawValue: product.0.productIdentifier)!, price: product.1) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                purchases.purchase(product.0)
                            }
                        }
                    }
                }
            }
        }
        .onReceive(purchases.loading) {
            loading = $0
        }
        .onReceive(purchases.error) {
            error = $0
        }
        .onReceive(purchases.products) {
            error = nil
            products = $0
        }
        .onAppear {
            purchases.load()
        }
    }
}

private struct Radiator: Shape {
    let value: CGFloat
    
    func path(in rect: CGRect) -> Path {
        .init {
            $0.move(to: .init(x: 0, y: rect.midY))
            $0.addLine(to: .init(x: rect.maxX * value, y: rect.midY))
        }
    }
}
