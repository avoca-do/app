import SwiftUI
import WidgetKit

extension Cards {
    struct Content: View {
        let entry: Entry
        @State private var decimal = NumberFormatter()
        @Environment(\.widgetFamily) private var family: WidgetFamily
        
        var body: some View {
            if entry == .empty {
                Text("Edit widget to continue")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                GeometryReader { proxy in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(verbatim: entry.board)
                                .font(family == .systemSmall ? .caption2 : .footnote)
                                .fontWeight(.heavy) +
                            Text(verbatim: ": ")
                                .font(family == .systemSmall ? .caption2 : .footnote) +
                            Text(verbatim: entry.column)
                                .font(family == .systemSmall ? .caption2 : .footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                            if family != .systemSmall {
                                ZStack {
                                    Circle()
                                        .fill(Color("avocado"))
                                        .frame(width: 30, height: 30)
                                    Text(NSNumber(value: entry.cards.count), formatter: decimal)
                                        .font(.caption2)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        ForEach(entry.cards, id: \.self) { card in
                            HStack(alignment: .top) {
                                Circle()
                                    .fill(Color("avocado"))
                                    .frame(width: 8, height: 8)
                                    .padding(.top, 4)
                                Text(verbatim: card)
                                    .font(family != .systemSmall ? .caption : .caption2)
                                    .redacted(reason: entry == .placeholder ? .placeholder : .init())
                                Spacer()
                            }
                            .padding(.top, 5)
                        }
                    }
                    .fixedSize(horizontal: false, vertical: family != .systemSmall)
                    .padding(family == .systemSmall ? 16 : 24)
                    .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                }
                .widgetURL(URL(string: "avocado://\(entry.id)")!)
                .onAppear {
                    decimal.numberStyle = .decimal
                }
            }
        }
    }
}
