import Foundation

extension Purchases {
    enum Item: String, CaseIterable {
        case
        plus_one = "avoca.do.plus.one"
        
        var image: String {
            switch self {
            case .plus_one: return "purchase"
            }
        }
        
        var title: String {
            switch self {
            case .plus_one: return "+1"
            }
        }
        
        var subtitle: String {
            switch self {
            case .plus_one: return "Increase your capacity by one"
            }
        }
        
        var info: String {
            switch self {
            case .plus_one: return """
Your projects capacity is permanent and won't expire, you can create and delete projects as many times as you want.

Projects are shared among all your devices, they can be small or very large and they need only 1 place in your capacity quota.

This purchase is consumable and you can purchase it many times.
"""
            }
        }
    }
}
