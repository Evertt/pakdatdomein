extension Fact: NodeConvertible {
    init(node: Node, in context: Context) throws {
        self.aggregateRootID = try node.extract("aggregateRootID")
        self.version         = try node.extract("version")
        self.event           = try node.extract("event")
    }

    func makeNode(context: Context) throws -> Node {
        return try [
            "aggregateRootID" : aggregateRootID.makeNode(),
            "version"         : version.makeNode(),
            "event"           : event.makeNode()
        ]
    }
}