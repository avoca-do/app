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
            case .plus_one: return """
Permanently increase your projects capacity by one.
Your capacity won't expire, you can create and delete projects as many times as you want.

This purchase is consumable and you can purchase it many times.
"""
            }
        }
    }
}
