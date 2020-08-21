public struct ID: Hashable {
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

extension ID: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(Int.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
