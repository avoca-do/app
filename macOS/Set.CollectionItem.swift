import Foundation

extension Set where Element == CollectionItem<Project.Info> {
    func drop(cell: Element, position: CGPoint) -> (column: Int, card: Int, point: CGPoint) {
        column(for: position.x) { column in
            card(for: position.y, in: column.info.id.column) { card in
                { index in
                    (column: column.info.id.column,
                     card: index,
                     point: column.info.id.column == cell.info.id.column && index == cell.info.id.card
                        ? cell.rect.origin
                        : .init(x: column.rect.minX,
                                y: card?.rect.maxY ?? column.rect.maxY))
                } (card
                    .map {
                        cell.info.id.column == column.info.id.column
                            ? $0.info.id.card >= cell.info.id.card
                                ? $0.info.id.card
                                : $0.info.id.card + 1
                            : $0.info.id.card + 1
                    }
                    ?? 0)
            }
        }
    }
    
    private func column<T>(for x: CGFloat, transform: (Element) -> T) -> T {
        transform(columns {
            $0
                .filter {
                    $0.rect.maxX > x
                }
                .first
                ?? $0.last!
        })
    }
    
    private func columns<T>(transform: ([Element]) -> T) -> T {
        transform(filter {
            if case .column = $0.info.id {
                return true
            }
            return false
        }
        .sorted {
            $0.rect.minX < $1.rect.minX
        })
    }
    
    private func card<T>(for y: CGFloat, in column: Int, transform: (Element?) -> T) -> T {
        transform(filter {
            if case .card = $0.info.id, $0.info.id.column == column {
                return true
            }
            return false
        }
        .sorted {
            $0.rect.minY < $1.rect.minY
        }
        .filter {
            $0.rect.midY < y
        }
        .last)
    }
}
