import Foundation

public struct Board: Codable {
    public var columns = [Column(name: "Do"), .init(name: "Doing"), .init(name: "Done")]
}
