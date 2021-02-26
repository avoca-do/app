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
        VStack(spacing: 0) {
            Title(session: $session, title: "Capacity")
            ScrollView {
                HStack {
                    Group {
                        Text(NSNumber(value: session.archive.count(.archive)), formatter: session.decimal)
                            .font(Font.title.bold()) +
                        Text(verbatim: " / ")
                            .font(.title) +
                        Text(NSNumber(value: session.archive.capacity), formatter: session.decimal)
                            .font(Font.title.bold())
                            .foregroundColor(.init(.tertiaryLabel))
                    }
                    Text("Projects")
                }
                .padding(.top, 40)
                ZStack {
                    Capsule()
                        .fill(Color.background)
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
        }
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
