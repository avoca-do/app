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
        ScrollView {
            HStack {
                Text(NSNumber(value: session.archive.count(.archive)), formatter: session.decimal)
                    .font(Font.title3.bold()) +
                Text(verbatim: " / ")
                    .font(.title3) +
                Text(NSNumber(value: session.archive.capacity), formatter: session.decimal)
                    .font(Font.title3.bold())
                    .foregroundColor(.init(.tertiaryLabel))
                Text("Projects")
                    .foregroundColor(.secondary)
            }
            .padding(.top, 20)
            ZStack {
                Capsule()
                    .fill(Color(white: 0, opacity: UIApplication.dark ? 1 : 0.2))
                if session.archive.available {
                    HStack {
                        Capsule()
                            .fill(Color.accentColor)
                            .frame(width: CGFloat(min(session.archive.count(.archive), session.archive.capacity)) / .init(session.archive.capacity) * 200)
                        Spacer()
                    }
                } else {
                    Capsule()
                        .fill(Color.pink)
                }
            }
            .frame(width: 200, height: 6)
            Text("You can purchase more capacity.\nYou could also delete any existing project to free up capacity.")
                .font(.footnote)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundColor(.secondary)
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding()
            if error != nil {
                Text(verbatim: error!)
                    .foregroundColor(.secondary)
                    .padding()
            } else if loading {
                Text("Loading")
                    .bold()
                    .foregroundColor(.secondary)
                    .padding()
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
