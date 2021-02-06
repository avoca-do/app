import Foundation

extension Field {
    enum Mode {
        case
        newBoard,
        newColumn(Int),
        board(Int),
        column(Int, Int)
    }
}
