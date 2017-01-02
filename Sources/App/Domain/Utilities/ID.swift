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

extension ID: NodeConvertible {
    init(node: Node, in context: Context) throws {
        guard let int = node.int else {
            throw NodeError.unableToConvert(node: node, expected: "\(Int.self)")
        }
        
        self = ID(int)
    }
    
    func makeNode(context: Context) throws -> Node {
        return Node(hashValue)
    }
}
