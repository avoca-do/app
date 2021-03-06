import SwiftUI
import StoreKit
import Kanban

struct Capacity: View {
    @Binding var session: Session
    @State private var products = [(SKProduct, String)]()
    @State private var error: String?
    @State private var loading = true
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        VStack {
            HStack {
                Text("Capacity")
                    .bold()
                Spacer()
                Text(NSNumber(value: session.archive.count(.archive)), formatter: session.decimal) +
                Text(verbatim: " / ") +
                Text(NSNumber(value: session.archive.capacity), formatter: session.decimal)
                    .foregroundColor(.secondary)
            }
            .padding([.horizontal, .top])
            GeometryReader { proxy in
                ZStack {
                    Capsule()
                        .fill(Color.primary.opacity(0.3))
                    if session.archive.available {
                        HStack {
                            Capsule()
                                .fill(Color.accentColor)
                                .frame(width: CGFloat(min(session.archive.count(.archive), session.archive.capacity)) / .init(session.archive.capacity) * proxy.size.width)
                            Spacer()
                        }
                    } else {
                        Capsule()
                            .fill(Color.pink)
                    }
                }
                .frame(width: proxy.size.width)
            }
            .frame(height: 6)
            .padding(.horizontal)
            Text("You can purchase more capacity.\nYou could also delete any existing project to free up capacity.")
                .font(.footnote)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(.secondary)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding()
            ZStack {
                RoundedRectangle(cornerRadius: Metrics.corners)
                    .fill(Color(.secondarySystemBackground))
                ScrollView {
                    Spacer()
                        .frame(height: 50)
                    if error != nil {
                        Text(verbatim: error!)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    } else if loading {
                        Text("Loading")
                            .bold()
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(products, id: \.0.productIdentifier) { product in
                            Item(purchase: Purchases.Item(rawValue: product.0.productIdentifier)!, price: product.1) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    session.purchases.purchase(product.0)
                                }
                            }
                        }
                    }
                    Spacer()
                        .frame(height: 20)
                }
                .padding(2)
            }
            .padding(.top)
        }
        .animation(.easeInOut(duration: 0.3))
        .onReceive(session.purchases.loading) {
            loading = $0
        }
        .onReceive(session.purchases.error) {
            error = $0
        }
        .onReceive(session.purchases.products) {
            error = nil
            products = $0
        }
        .onAppear {
            error = nil
            session.purchases.load()
        }
    }
}
