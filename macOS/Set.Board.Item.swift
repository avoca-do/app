import Foundation

extension Set where Element == Board.Item {
    var columns: Self {
        filter {
            if case .column = $0.path {
                return true
            }
            return false
        }
    }
    
    var cards: Self {
        filter {
            if case .card = $0.path {
                return true
            }
            return false
        }
    }
}
