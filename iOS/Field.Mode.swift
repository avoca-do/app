import Foundation

extension Field {
    enum Mode: Equatable {
        case
        newBoard,
        newColumn(Int),
        board(Int),
        column(Int, Int)
    }
}
