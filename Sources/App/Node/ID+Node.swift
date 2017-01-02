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