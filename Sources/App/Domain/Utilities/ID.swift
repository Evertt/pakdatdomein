struct ID: Hashable, CustomStringConvertible {
    static var seed = 0
    let hashValue   : Int
    let description : String
    
    init() {
        ID.seed += 1
        self.init(ID.seed)
    }
    
    init(_ id: Int) {
        hashValue   = id
        description = "\(id)"
    }
    
    static func ==(left: ID, right: ID) -> Bool {
        return left.hashValue == right.hashValue
    }
}

extension ID: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Int) {
        self.init(value)
    }
}
