public struct ID: Hashable, CustomStringConvertible {
    static var seed = 0
    public let value: Int
    public let description: String
    
    public init() {
        ID.seed += 1
        self.init(ID.seed)
    }
    
    init(_ value: Int) {
        self.value = value
        self.description = "\(value)"
    }
    
    public static func ==(left: ID, right: ID) -> Bool {
        return left.value == right.value
    }
}

extension ID: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
