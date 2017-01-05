public struct ID: Hashable, CustomStringConvertible {
    static var seed = 0
    public let hashValue   : Int
    public let description : String
    
    public init() {
        ID.seed += 1
        self.init(ID.seed)
    }
    
    init(_ id: Int) {
        hashValue   = id
        description = "\(id)"
    }
    
    public static func ==(left: ID, right: ID) -> Bool {
        return left.hashValue == right.hashValue
    }
}

extension ID: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self.init(value)
    }
}
