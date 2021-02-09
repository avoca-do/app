import SwiftUI
import StoreKit
import Kanban

struct Capacity: View {
    @Binding var session: Session
    @State private var products = [(SKProduct, String)]()
    @State private var error: String?
    @State private var loading = true
    @AppStorage(Defaults.Key.capacity.rawValue) private var capacity = 1
    @Environment(\.presentationMode) private var visible
    
    var body: some View {
        ScrollView {
            Title(session: $session, title: "Capacity")
            HStack {
                Group {
                    Text(NSNumber(value: session.count), formatter: session.decimal) +
                    Text(verbatim: "/") +
                    Text(NSNumber(value: capacity), formatter: session.decimal)
                }
                .font(Font.title.bold())
                Text("Projects")
            }
            ZStack {
                Capsule()
                    .fill(Color.background)
                if session.count >= capacity {
                    Capsule()
                        .fill(Color.pink)
                } else {
                    HStack {
                        Capsule()
                            .fill(Color.accentColor)
                            .frame(width: CGFloat(session.count) / .init(capacity) * 200)
                        Spacer()
                    }
                }
            }
            .frame(width: 200, height: 10)
            .padding(.bottom)
            HStack {
                VStack(alignment: .leading) {
                    Text("You can purchase more capacity.")
                    Text("You could also delete any existing project to free up capacity.")
                }
                .foregroundColor(.secondary)
                .padding(.horizontal)
                Spacer()
            }
            .padding()
            if error != nil {
                HStack {
                    Spacer()
                    Text(verbatim: error!)
                        .foregroundColor(.secondary)
                        .padding(.top)
                        .padding()
                    Spacer()
                }
            } else if loading {
                HStack {
                    Spacer()
                    Text("Loading")
                        .bold()
                        .foregroundColor(.secondary)
                        .padding(.top)
                        .padding()
                    Spacer()
                }
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
                .frame(height: 30)
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
