import Foundation

extension Set where Element == Board.Cell {
    var columns: Self {
        filter {
            if case .column = $0.item?.path {
                return true
            }
            return false
        }
    }
    
    var cards: Self {
        filter {
            if case .card = $0.item?.path {
                return true
            }
            return false
        }
    }
}
