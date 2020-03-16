public struct ID: Codable, Hashable {
    static var seed = 0
    public let value: Int
    
    public init() {
        ID.seed += 1
        self.init(ID.seed)
    }
    
    public init(_ value: Int) {
        self.value = value
    }
}

extension ID: CustomStringConvertible {
    public var description: String {
        return "\(value)"
    }
}

extension ID: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
